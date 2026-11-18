# Combine per-sample featureCounts output files into a DESeq2-ready count matrix.

# Input featureCounts directory
COUNT_DIR = "counts"

# Input sample design file
DESIGN_FILE = "design.csv"

# Output combined count matrix
COUNT_FILE = "results/gene_counts.csv"

# featureCounts count file extension
COUNT_EXTENSION = "txt"

# --- all definitions above the line, all code below the line ---

message("Reading sample information from: ", DESIGN_FILE)

if (!file.exists(DESIGN_FILE)) {
    stop("Design file not found: ", DESIGN_FILE)
}

design <- read.csv(DESIGN_FILE, stringsAsFactors = FALSE, check.names = FALSE)

if (!"sample" %in% names(design)) {
    stop("Design file must contain a 'sample' column: ", DESIGN_FILE)
}

sample_names <- design$sample

if (any(is.na(sample_names) | sample_names == "")) {
    stop("Design file contains a missing or empty sample name")
}

if (length(unique(sample_names)) != length(sample_names)) {
    stop("Design file contains duplicate sample names")
}

message("Reading featureCounts files from: ", COUNT_DIR)

if (!dir.exists(COUNT_DIR)) {
    stop("Count directory not found: ", COUNT_DIR)
}

disk_files <- list.files(
    COUNT_DIR,
    pattern = paste0("\\.", COUNT_EXTENSION, "$"),
    full.names = FALSE
)

disk_files <- disk_files[!grepl("\\.summary$", disk_files)]
disk_sample_names <- sub(paste0("\\.", COUNT_EXTENSION, "$"), "", disk_files)

missing_samples <- setdiff(sample_names, disk_sample_names)
if (length(missing_samples) > 0) {
    stop(
        "Expected count files are missing for samples: ",
        paste(missing_samples, collapse = ", "),
        ". Expected files: ",
        paste(file.path(COUNT_DIR, paste0(missing_samples, ".", COUNT_EXTENSION)),
              collapse = ", ")
    )
}

extra_samples <- setdiff(disk_sample_names, sample_names)
if (length(extra_samples) > 0) {
    stop(
        "Count files found on disk do not match sample names in ",
        DESIGN_FILE,
        ". Unexpected samples: ",
        paste(extra_samples, collapse = ", ")
    )
}

count_matrices <- list()
gene_ids <- NULL

for (sample_name in sample_names) {
    count_file <- file.path(COUNT_DIR, paste0(sample_name, ".", COUNT_EXTENSION))

    if (!file.exists(count_file)) {
        stop("Missing expected count file: ", count_file)
    }

    message("Loading count file: ", count_file)

    counts <- read.delim(
        count_file,
        sep = "\t",
        header = TRUE,
        comment.char = "#",
        check.names = FALSE,
        stringsAsFactors = FALSE
    )

    if (!"Geneid" %in% names(counts) || ncol(counts) < 7) {
        stop("Unexpected featureCounts format in: ", count_file)
    }

    count_values <- counts[[ncol(counts)]]

    if (any(is.na(count_values))) {
        stop("Missing count values found in: ", count_file)
    }

    if (!is.numeric(count_values)) {
        count_values <- suppressWarnings(as.numeric(count_values))
        if (any(is.na(count_values))) {
            stop("Non-numeric count values found in: ", count_file)
        }
    }

    if (any(count_values != as.integer(count_values))) {
        stop("Non-integer count values found in: ", count_file)
    }

    count_values <- as.integer(count_values)

    if (length(unique(counts$Geneid)) != length(counts$Geneid)) {
        stop("Duplicate Geneid values found in: ", count_file)
    }

    if (is.null(gene_ids)) {
        gene_ids <- counts$Geneid
    } else if (!identical(counts$Geneid, gene_ids)) {
        stop(
            "Gene rows do not match across count files; first mismatch differs from: ",
            count_file
        )
    }

    count_matrices[[sample_name]] <- count_values
}

gene_count_matrix <- as.data.frame(count_matrices, check.names = FALSE)
names(gene_count_matrix) <- sample_names
gene_count_matrix <- cbind(Geneid = gene_ids, gene_count_matrix)

output_dir <- dirname(COUNT_FILE)
if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
}

message("Saving combined gene count matrix to: ", COUNT_FILE)

write.csv(
    gene_count_matrix,
    file = COUNT_FILE,
    row.names = FALSE,
    quote = FALSE
)
