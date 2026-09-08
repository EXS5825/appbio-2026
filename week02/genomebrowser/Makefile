import javax.swing.*;
import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.*;
import java.util.List;

/**
 * GenomeBrowser — a two-track Swing genome browser.
 *
 * Developed for GCA_000441915.1 (Genlisea aurea, GenAur_1.0) but works with
 * any standard FASTA + GFF3 file pair.
 *
 * Usage:
 *   javac src/browser.java -d out
 *   java -cp out browser GCA_000441915.1_genomic.fna GCA_000441915.1_genomic.gff
 */
public class browser {
    public static void main(String[] args) throws Exception {
        UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        SwingUtilities.invokeLater(() -> {
            String fastaPath = args.length > 0 ? args[0] : null;
            String gffPath   = args.length > 1 ? args[1] : null;
            new BrowserFrame(fastaPath, gffPath).setVisible(true);
        });
    }
}

// ── Colour palette (separate class avoids name clash with field 'browser') ───

class C {
    static final Color BG         = new Color(0x0F1117);
    static final Color PANEL_BG   = new Color(0x161B25);
    static final Color TRACK_BG   = new Color(0x1C2333);
    static final Color GUTTER_BG  = new Color(0x1A2035);
    static final Color BORDER     = new Color(0x2A3347);
    static final Color RULER_FG   = new Color(0x6B7FA3);
    static final Color LABEL_FG   = new Color(0xCDD6F4);
    static final Color ACCENT     = new Color(0x7C83FD);
    static final Color SEQ_A      = new Color(0x4FC3F7);
    static final Color SEQ_T      = new Color(0xEF9A9A);
    static final Color SEQ_G      = new Color(0xA5D6A7);
    static final Color SEQ_C      = new Color(0xFFCC80);
    static final Color SEQ_N      = new Color(0x4A5568);
    static final Color FEAT_GENE  = new Color(0x7C83FD);
    static final Color FEAT_CDS   = new Color(0xF9A825);
    static final Color FEAT_EXON  = new Color(0x66BB6A);
    static final Color FEAT_MRNA  = new Color(0xEF5350);
    static final Color FEAT_OTHER = new Color(0x78909C);
}

// ── Data model ───────────────────────────────────────────────────────────────

class FastaRecord {
    final String id, sequence;
    FastaRecord(String id, String seq) { this.id = id; this.sequence = seq; }
    int length() { return sequence.length(); }
}

class GffFeature {
    final String seqId, source, type, strand, attributes;
    final int start, end;
    final String name;

    GffFeature(String seqId, String source, String type,
               int start, int end, String strand, String attributes) {
        this.seqId = seqId; this.source = source; this.type = type;
        this.start = start; this.end = end;
        this.strand = strand; this.attributes = attributes;
        this.name = extractName(attributes, type);
    }

    private static String extractName(String attr, String type) {
        if (attr == null || attr.equals(".")) return type;
        String[] priority = {"name", "gene", "locus_tag", "product", "id"};
        Map<String, String> kv = new LinkedHashMap<>();
        for (String pair : attr.split(";")) {
            String[] p = pair.trim().split("=", 2);
            if (p.length == 2) kv.put(p[0].trim().toLowerCase(), p[1].trim());
        }
        for (String key : priority)
            if (kv.containsKey(key)) return kv.get(key);
        return type;
    }

    Color color() {
        return switch (type.toLowerCase()) {
            case "gene"                      -> C.FEAT_GENE;
            case "cds"                       -> C.FEAT_CDS;
            case "exon"                      -> C.FEAT_EXON;
            case "mrna","rna","transcript"   -> C.FEAT_MRNA;
            default                          -> C.FEAT_OTHER;
        };
    }

    boolean isRegion() {
        String t = type.toLowerCase();
        return t.equals("region") || t.equals("chromosome");
    }
}

// ── Parsers ──────────────────────────────────────────────────────────────────

class FastaParser {
    static List<FastaRecord> parse(String path) throws IOException {
        List<FastaRecord> records = new ArrayList<>();
        String id = null;
        StringBuilder seq = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            while ((line = br.readLine()) != null) {
                line = line.strip();
                if (line.startsWith(">")) {
                    if (id != null) records.add(new FastaRecord(id, seq.toString()));
                    id  = line.substring(1).split("\\s+")[0];
                    seq = new StringBuilder();
                } else if (!line.isEmpty() && !line.startsWith(";")) {
                    seq.append(line.toUpperCase());
                }
            }
            if (id != null) records.add(new FastaRecord(id, seq.toString()));
        }
        return records;
    }
}

class GffParser {
    static List<GffFeature> parse(String path) throws IOException {
        List<GffFeature> features = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.isBlank() || line.startsWith("#")) continue;
                String[] f = line.split("\t", -1);
                if (f.length < 8) continue;
                try {
                    int start = Integer.parseInt(f[3].trim());
                    int end   = Integer.parseInt(f[4].trim());
                    String attrs = f.length > 8 ? urlDecode(f[8].trim()) : ".";
                    features.add(new GffFeature(
                        f[0].trim(), f[1].trim(), f[2].trim(),
                        start, end, f[6].trim(), attrs));
                } catch (NumberFormatException ignored) {}
            }
        }
        return features;
    }

    static String urlDecode(String s) {
        if (!s.contains("%")) return s;
        StringBuilder sb = new StringBuilder(s.length());
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (c == '%' && i + 2 < s.length()) {
                try {
                    sb.append((char) Integer.parseInt(s.substring(i+1, i+3), 16));
                    i += 2;
                } catch (NumberFormatException e) { sb.append(c); }
            } else { sb.append(c); }
        }
        return sb.toString();
    }
}

// ── Main window ──────────────────────────────────────────────────────────────

class BrowserFrame extends JFrame {

    FastaRecord       currentSeq;
    List<FastaRecord> sequences = new ArrayList<>();
    List<GffFeature>  features  = new ArrayList<>();
    int viewStart, viewEnd;

    JComboBox<String> seqChooser;
    JTextField        coordField;
    JLabel            statusLabel;
    RulerTrack        ruler;
    SequenceTrack     seqTrack;
    GffTrack          gffTrack;

    BrowserFrame(String fastaPath, String gffPath) {
        super("Genome Browser — Genlisea aurea (GCA_000441915.1 / GenAur_1.0)");
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setPreferredSize(new Dimension(1280, 780));
        buildUI();
        buildMenu();
        pack();
        setLocationRelativeTo(null);
        if (fastaPath != null) loadFasta(fastaPath);
        if (gffPath   != null) loadGff(gffPath);
    }

    void buildUI() {
        getContentPane().setBackground(C.BG);
        setLayout(new BorderLayout());

        // toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 6));
        toolbar.setBackground(C.PANEL_BG);
        toolbar.setBorder(BorderFactory.createMatteBorder(0, 0, 1, 0, C.BORDER));

        seqChooser = new JComboBox<>();
        seqChooser.setBackground(C.TRACK_BG);
        seqChooser.setForeground(C.LABEL_FG);
        seqChooser.setPreferredSize(new Dimension(220, 28));
        seqChooser.addActionListener(e -> {
            int i = seqChooser.getSelectedIndex();
            if (i >= 0 && i < sequences.size()) selectSequence(sequences.get(i));
        });

        JButton zoomIn  = btn("＋"); zoomIn .addActionListener(e -> zoom(0.5));
        JButton zoomOut = btn("－"); zoomOut.addActionListener(e -> zoom(2.0));
        JButton left    = btn("◀");  left   .addActionListener(e -> pan(-0.25));
        JButton right   = btn("▶");  right  .addActionListener(e -> pan( 0.25));
        JButton fitAll  = btn("Fit"); fitAll.addActionListener(e -> fitAll());

        coordField = new JTextField(18);
        coordField.setBackground(C.TRACK_BG);
        coordField.setForeground(C.LABEL_FG);
        coordField.setCaretColor(C.LABEL_FG);
        coordField.setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createLineBorder(C.BORDER),
            BorderFactory.createEmptyBorder(2, 6, 2, 6)));
        coordField.addActionListener(e -> jumpTo(coordField.getText()));

        JButton go = btn("Go"); go.addActionListener(e -> jumpTo(coordField.getText()));

        toolbar.add(lbl("Sequence:")); toolbar.add(seqChooser);
        toolbar.add(Box.createHorizontalStrut(8));
        toolbar.add(left); toolbar.add(right);
        toolbar.add(Box.createHorizontalStrut(4));
        toolbar.add(zoomIn); toolbar.add(zoomOut); toolbar.add(fitAll);
        toolbar.add(Box.createHorizontalStrut(8));
        toolbar.add(lbl("Region:")); toolbar.add(coordField); toolbar.add(go);
        add(toolbar, BorderLayout.NORTH);

        // tracks
        ruler    = new RulerTrack(this);
        seqTrack = new SequenceTrack(this);
        gffTrack = new GffTrack(this);

        JPanel tracks = new JPanel();
        tracks.setLayout(new BoxLayout(tracks, BoxLayout.Y_AXIS));
        tracks.setBackground(C.BG);
        tracks.add(ruler);
        tracks.add(Box.createVerticalStrut(4));
        tracks.add(seqTrack);
        tracks.add(Box.createVerticalStrut(4));
        tracks.add(gffTrack);
        tracks.add(Box.createVerticalGlue());

        JScrollPane scroll = new JScrollPane(tracks);
        scroll.setBorder(null);
        scroll.getViewport().setBackground(C.BG);
        scroll.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);
        add(scroll, BorderLayout.CENTER);

        // status bar
        statusLabel = new JLabel(" Ready — open a FASTA and GFF file via the File menu");
        statusLabel.setFont(new Font("Monospaced", Font.PLAIN, 11));
        statusLabel.setForeground(C.RULER_FG);
        statusLabel.setBackground(C.PANEL_BG);
        statusLabel.setOpaque(true);
        statusLabel.setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createMatteBorder(1, 0, 0, 0, C.BORDER),
            BorderFactory.createEmptyBorder(4, 8, 4, 8)));
        add(statusLabel, BorderLayout.SOUTH);

        // mouse wheel zoom
        MouseWheelListener mwl = e -> zoom(e.getWheelRotation() > 0 ? 1.3 : 0.77);
        ruler.addMouseWheelListener(mwl);
        seqTrack.addMouseWheelListener(mwl);
        gffTrack.addMouseWheelListener(mwl);

        // drag pan
        addDrag(seqTrack); addDrag(gffTrack);
    }

    void buildMenu() {
        JMenuBar bar = new JMenuBar();
        bar.setBackground(C.PANEL_BG);
        JMenu file = new JMenu("File");
        file.setForeground(C.LABEL_FG);
        JMenuItem oFasta = new JMenuItem("Open FASTA…");
        JMenuItem oGff   = new JMenuItem("Open GFF/GFF3…");
        JMenuItem quit   = new JMenuItem("Quit");
        oFasta.addActionListener(e -> pick("fasta"));
        oGff  .addActionListener(e -> pick("gff"));
        quit  .addActionListener(e -> System.exit(0));
        file.add(oFasta); file.add(oGff); file.addSeparator(); file.add(quit);
        bar.add(file);
        setJMenuBar(bar);
    }

    void pick(String kind) {
        JFileChooser fc = new JFileChooser();
        if (fc.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            String p = fc.getSelectedFile().getAbsolutePath();
            if (kind.equals("fasta")) loadFasta(p); else loadGff(p);
        }
    }

    void loadFasta(String path) {
        new SwingWorker<List<FastaRecord>, Void>() {
            protected List<FastaRecord> doInBackground() throws Exception {
                status("Loading FASTA…"); return FastaParser.parse(path);
            }
            protected void done() {
                try {
                    sequences = get();
                    seqChooser.removeAllItems();
                    for (FastaRecord r : sequences)
                        seqChooser.addItem(r.id + "  (" + r.length() + " bp)");
                    if (!sequences.isEmpty()) selectSequence(sequences.get(0));
                    status("Loaded " + sequences.size() + " sequence(s) from " + path);
                } catch (Exception ex) { err(ex); }
            }
        }.execute();
    }

    void loadGff(String path) {
        new SwingWorker<List<GffFeature>, Void>() {
            protected List<GffFeature> doInBackground() throws Exception {
                status("Loading GFF…"); return GffParser.parse(path);
            }
            protected void done() {
                try {
                    features = get();
                    gffTrack.repaint();
                    status("Loaded " + features.size() + " feature(s) from " + path);
                } catch (Exception ex) { err(ex); }
            }
        }.execute();
    }

    void selectSequence(FastaRecord r) {
        currentSeq = r; viewStart = 0; viewEnd = r.length();
        repaintAll(); updateCoord();
    }

    void fitAll() {
        if (currentSeq == null) return;
        viewStart = 0; viewEnd = currentSeq.length();
        repaintAll(); updateCoord();
    }

    void zoom(double factor) {
        if (currentSeq == null) return;
        int mid = (viewStart + viewEnd) / 2;
        int half = (int) Math.max(10, (viewEnd - viewStart) * factor / 2.0);
        viewStart = Math.max(0, mid - half);
        viewEnd   = Math.min(currentSeq.length(), mid + half);
        repaintAll(); updateCoord();
    }

    void pan(double frac) {
        if (currentSeq == null) return;
        int span  = viewEnd - viewStart;
        int delta = (int) (span * frac);
        viewStart = Math.max(0, viewStart + delta);
        viewEnd   = Math.min(currentSeq.length(), viewStart + span);
        if (viewEnd == currentSeq.length()) viewStart = viewEnd - span;
        repaintAll(); updateCoord();
    }

    void jumpTo(String text) {
        if (currentSeq == null || text == null) return;
        text = text.trim();
        try {
            String[] p = text.split("[-:]");
            if (p.length >= 2) {
                viewStart = Math.max(0, Integer.parseInt(p[0].replaceAll("[^0-9]","")) - 1);
                viewEnd   = Math.min(currentSeq.length(), Integer.parseInt(p[1].replaceAll("[^0-9]","")));
            } else {
                int pos = Integer.parseInt(text.replaceAll("[^0-9]","")) - 1;
                viewStart = Math.max(0, pos - 1000);
                viewEnd   = Math.min(currentSeq.length(), pos + 1000);
            }
        } catch (NumberFormatException e) { status("Cannot parse: " + text); return; }
        repaintAll(); updateCoord();
    }

    void repaintAll() { ruler.repaint(); seqTrack.repaint(); gffTrack.repaint(); }

    void updateCoord() {
        if (currentSeq == null) return;
        coordField.setText((viewStart+1) + "-" + viewEnd);
        status(currentSeq.id + "  " + (viewStart+1) + "–" + viewEnd
               + "  (" + (viewEnd-viewStart) + " bp)");
    }

    void status(String msg) { SwingUtilities.invokeLater(() -> statusLabel.setText(" " + msg)); }
    void err(Exception ex)  { status("Error: " + ex.getMessage()); }

    JLabel lbl(String t) {
        JLabel l = new JLabel(t); l.setForeground(C.RULER_FG);
        l.setFont(new Font("SansSerif", Font.PLAIN, 12)); return l;
    }

    JButton btn(String t) {
        JButton b = new JButton(t);
        b.setBackground(C.TRACK_BG); b.setForeground(C.LABEL_FG);
        b.setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createLineBorder(C.BORDER),
            BorderFactory.createEmptyBorder(3, 10, 3, 10)));
        b.setFocusPainted(false);
        b.setCursor(Cursor.getPredefinedCursor(Cursor.HAND_CURSOR));
        return b;
    }

    void addDrag(JComponent comp) {
        int[] ox = {0}; int[] sv = {0, 0};
        comp.addMouseListener(new MouseAdapter() {
            public void mousePressed(MouseEvent e) {
                ox[0] = e.getX(); sv[0] = viewStart; sv[1] = viewEnd;
            }
        });
        comp.addMouseMotionListener(new MouseMotionAdapter() {
            public void mouseDragged(MouseEvent e) {
                if (currentSeq == null) return;
                int span  = sv[1] - sv[0];
                int delta = (int) ((ox[0] - e.getX()) / (double) comp.getWidth() * span);
                viewStart = Math.max(0, sv[0] + delta);
                viewEnd   = Math.min(currentSeq.length(), viewStart + span);
                if (viewEnd == currentSeq.length()) viewStart = viewEnd - span;
                repaintAll(); updateCoord();
            }
        });
    }
}

// ── Ruler track ──────────────────────────────────────────────────────────────

class RulerTrack extends JPanel {
    final BrowserFrame B;
    RulerTrack(BrowserFrame b) {
        B = b; setPreferredSize(new Dimension(0, 36));
        setMaximumSize(new Dimension(Integer.MAX_VALUE, 36));
        setBackground(C.BG);
    }
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        int w = getWidth(), gutter = 120;
        g2.setColor(C.GUTTER_BG); g2.fillRect(0, 0, gutter, getHeight());
        g2.setColor(C.ACCENT); g2.setFont(new Font("Monospaced", Font.BOLD, 11));
        g2.drawString("Ruler", 8, 22);
        if (B.currentSeq == null) return;

        int vs = B.viewStart, ve = B.viewEnd, span = ve - vs;
        int[] steps = {1,2,5,10,20,50,100,200,500,1000,2000,5000,
                       10000,20000,50000,100000,500000,1000000};
        int interval = 1000;
        for (int s : steps) { if ((double)span/s <= 10) { interval = s; break; } }

        g2.setFont(new Font("Monospaced", Font.PLAIN, 10));
        FontMetrics fm = g2.getFontMetrics();
        for (int pos = (vs/interval+1)*interval; pos < ve; pos += interval) {
            int x = gutter + (int)((pos-vs)/(double)span*(w-gutter));
            g2.setColor(C.BORDER); g2.drawLine(x, 0, x, getHeight());
            g2.setColor(C.RULER_FG);
            String lbl = pos >= 1_000_000 ? String.format("%.1fMb",pos/1e6)
                       : pos >= 1_000     ? String.format("%.0fkb",pos/1e3)
                       : pos + "bp";
            g2.drawString(lbl, x - fm.stringWidth(lbl)/2, getHeight()-6);
        }
        g2.setColor(C.BORDER); g2.drawLine(gutter, getHeight()-1, w, getHeight()-1);
    }
}

// ── Sequence track ───────────────────────────────────────────────────────────

class SequenceTrack extends JPanel {
    final BrowserFrame B;
    SequenceTrack(BrowserFrame b) {
        B = b; setPreferredSize(new Dimension(0, 80));
        setMaximumSize(new Dimension(Integer.MAX_VALUE, 80));
        setBackground(C.BG);
    }
    public void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        int w = getWidth(), h = getHeight(), gutter = 120;

        g2.setColor(C.GUTTER_BG); g2.fillRect(0, 0, gutter, h);
        g2.setColor(C.ACCENT); g2.setFont(new Font("Monospaced", Font.BOLD, 11));
        g2.drawString("Sequence", 8, 18);
        if (B.currentSeq != null) {
            g2.setColor(C.RULER_FG); g2.setFont(new Font("Monospaced", Font.PLAIN, 10));
            g2.drawString(B.currentSeq.id, 8, 32);
            g2.drawString(B.currentSeq.length() + " bp", 8, 46);
        }

        g2.setColor(C.TRACK_BG); g2.fillRect(gutter, 0, w-gutter, h);
        g2.setColor(C.BORDER);   g2.drawRect(gutter, 0, w-gutter-1, h-1);

        if (B.currentSeq == null) {
            g2.setColor(C.RULER_FG); g2.setFont(new Font("SansSerif", Font.PLAIN, 13));
            g2.drawString("Open a FASTA file via File → Open FASTA…", gutter+16, h/2+5);
            return;
        }

        String seq  = B.currentSeq.sequence;
        int vs = B.viewStart, ve = B.viewEnd, span = ve-vs, trackW = w-gutter;

        if (span > trackW/8) {
            // GC content bar chart
            int bins = Math.min(trackW, 600), barH = h-24, yBase = h-12;
            g2.setColor(C.RULER_FG); g2.setFont(new Font("Monospaced", Font.PLAIN, 9));
            g2.drawString("GC%", gutter+4, 14);
            for (int b = 0; b < bins; b++) {
                int s = vs + (int)(b*(double)span/bins);
                int e = Math.min(vs + (int)((b+1)*(double)span/bins), ve);
                int gc = 0;
                for (int i = s; i < e && i < seq.length(); i++) {
                    char c = seq.charAt(i); if (c=='G'||c=='C') gc++;
                }
                double frac = (e>s) ? gc/(double)(e-s) : 0;
                int bh = (int)(frac*barH);
                int x  = gutter + (int)(b*(double)trackW/bins);
                int bw = Math.max(1, (int)((double)trackW/bins));
                g2.setColor(frac>0.6 ? C.SEQ_G : frac>0.4 ? C.SEQ_A : C.SEQ_T);
                g2.fillRect(x, yBase-bh, bw, bh);
            }
        } else {
            // per-base coloured boxes
            double bpx = (double)trackW/span;
            int boxH = h-16;
            g2.setFont(new Font("Monospaced", Font.BOLD, Math.min(14,(int)bpx-2)));
            FontMetrics fm = g2.getFontMetrics();
            for (int i = vs; i < ve; i++) {
                char c  = (i < seq.length()) ? seq.charAt(i) : 'N';
                int  x  = gutter + (int)((i-vs)*bpx);
                int  bw = Math.max(1, (int)bpx-1);
                g2.setColor(switch(c){
                    case 'A'->C.SEQ_A; case 'T'->C.SEQ_T;
                    case 'G'->C.SEQ_G; case 'C'->C.SEQ_C; default->C.SEQ_N;});
                g2.fillRoundRect(x, 8, bw, boxH, 3, 3);
                if (bpx >= 12) {
                    g2.setColor(new Color(0,0,0,160));
                    g2.drawString(String.valueOf(c),
                        x+(bw-fm.charWidth(c))/2, 8+(boxH+fm.getAscent())/2-2);
                }
            }
        }
    }
}

// ── GFF annotation track ─────────────────────────────────────────────────────

class GffTrack extends JPanel {
    final BrowserFrame B;
    static final int ROW_H = 20, ROW_GAP = 4;
    record FR(GffFeature f, Rectangle r) {}
    List<FR> hits = new ArrayList<>();

    GffTrack(BrowserFrame b) {
        B = b; setBackground(C.BG);
        setToolTipText("");
        ToolTipManager.sharedInstance().setInitialDelay(150);
        addMouseMotionListener(new MouseMotionAdapter() {
            public void mouseMoved(MouseEvent e) {
                for (FR fr : hits) {
                    if (fr.r().contains(e.getPoint())) {
                        GffFeature f = fr.f();
                        setToolTipText("<html><b>" + f.type + "</b>: " + f.name
                            + "<br>" + f.seqId + ":" + f.start + "–" + f.end
                            + " (" + (f.end-f.start+1) + " bp, " + f.strand + ")"
                            + extraAttrs(f.attributes) + "</html>");
                        return;
                    }
                }
                setToolTipText(null);
            }
            String extraAttrs(String attrs) {
                if (attrs==null||attrs.equals(".")) return "";
                StringBuilder sb = new StringBuilder();
                for (String kv : attrs.split(";")) {
                    String[] p = kv.trim().split("=",2);
                    if (p.length!=2) continue;
                    String k = p[0].trim().toLowerCase();
                    if (k.equals("locus_tag")||k.equals("product")||k.equals("note"))
                        sb.append("<br>").append(p[0].trim()).append(": ").append(p[1].trim());
                }
                return sb.toString();
            }
        });
    }

    int countRows() {
        if (B.currentSeq==null||B.features.isEmpty()) return 1;
        List<Integer> ends = new ArrayList<>();
        for (GffFeature f : B.features) {
            if (!f.seqId.equals(B.currentSeq.id)||f.isRegion()) continue;
            if (f.end<B.viewStart+1||f.start>B.viewEnd) continue;
            boolean placed = false;
            for (int r=0;r<ends.size();r++)
                if (ends.get(r)<f.start-5){ends.set(r,f.end);placed=true;break;}
            if (!placed) ends.add(f.end);
        }
        return Math.max(1, ends.size());
    }

    public Dimension getPreferredSize() {
        return new Dimension(0, Math.max(60, 16+countRows()*(ROW_H+ROW_GAP)+8));
    }

    public void paintComponent(Graphics g) {
        int needed = Math.max(60, 16+countRows()*(ROW_H+ROW_GAP)+8);
        if (getPreferredSize().height != needed) {
            setPreferredSize(new Dimension(0, needed)); revalidate();
        }
        super.paintComponent(g);
        hits.clear();
        Graphics2D g2 = (Graphics2D) g;
        g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        int w = getWidth(), h = getHeight(), gutter = 120;

        // gutter
        g2.setColor(C.GUTTER_BG); g2.fillRect(0,0,gutter,h);
        g2.setColor(C.ACCENT); g2.setFont(new Font("Monospaced",Font.BOLD,11));
        g2.drawString("Annotations", 8, 18);
        if (!B.features.isEmpty()) {
            g2.setFont(new Font("Monospaced",Font.PLAIN,10));
            long vis = B.features.stream().filter(f -> B.currentSeq!=null
                && f.seqId.equals(B.currentSeq.id)
                && f.end>=B.viewStart+1 && f.start<=B.viewEnd).count();
            g2.setColor(C.RULER_FG); g2.drawString(vis+" visible", 8, 30);
            // legend
            Object[][] legend = {
                {"gene",C.FEAT_GENE},{"mRNA",C.FEAT_MRNA},
                {"CDS",C.FEAT_CDS},{"exon",C.FEAT_EXON},{"other",C.FEAT_OTHER}};
            int ly = 44;
            for (Object[] e : legend) {
                g2.setColor((Color)e[1]); g2.fillRoundRect(6,ly-9,10,10,3,3);
                g2.setColor(C.RULER_FG); g2.drawString((String)e[0], 20, ly);
                ly += 13;
            }
        }

        // track area
        g2.setColor(C.TRACK_BG); g2.fillRect(gutter,0,w-gutter,h);
        g2.setColor(C.BORDER);   g2.drawRect(gutter,0,w-gutter-1,h-1);

        if (B.currentSeq==null) {
            g2.setColor(C.RULER_FG); g2.setFont(new Font("SansSerif",Font.PLAIN,13));
            g2.drawString("Load a FASTA file then a GFF file to see annotations.", gutter+16, h/2+5);
            return;
        }
        if (B.features.isEmpty()) {
            g2.setColor(C.RULER_FG); g2.setFont(new Font("SansSerif",Font.PLAIN,13));
            g2.drawString("No GFF file loaded. Use File → Open GFF/GFF3…", gutter+16, h/2+5);
            return;
        }

        int vs=B.viewStart, ve=B.viewEnd, span=ve-vs, trackW=w-gutter;
        List<Integer> rowEnds = new ArrayList<>();
        g2.setFont(new Font("SansSerif",Font.PLAIN,10));
        FontMetrics fm = g2.getFontMetrics();

        // region baseline
        for (GffFeature f : B.features) {
            if (!f.seqId.equals(B.currentSeq.id)||!f.isRegion()) continue;
            if (f.end<vs+1||f.start>ve) continue;
            int x1=gutter+(int)((Math.max(f.start-1,vs)-vs)/(double)span*trackW);
            int x2=gutter+(int)((Math.min(f.end,ve)-vs)/(double)span*trackW);
            g2.setColor(C.BORDER); g2.fillRect(x1, 3, Math.max(2,x2-x1), 3);
        }

        // feature rows
        for (GffFeature f : B.features) {
            if (!f.seqId.equals(B.currentSeq.id)||f.isRegion()) continue;
            if (f.end<vs+1||f.start>ve) continue;

            int row=-1;
            for (int r=0;r<rowEnds.size();r++)
                if (rowEnds.get(r)<f.start-5){row=r;rowEnds.set(r,f.end);break;}
            if (row<0){row=rowEnds.size();rowEnds.add(f.end);}

            int x1=gutter+(int)((Math.max(f.start-1,vs)-vs)/(double)span*trackW);
            int x2=gutter+(int)((Math.min(f.end,ve)-vs)/(double)span*trackW);
            int fw=Math.max(2,x2-x1), y=8+row*(ROW_H+ROW_GAP);

            Color col = f.color();
            g2.setColor(col); g2.fillRoundRect(x1,y,fw,ROW_H,6,6);

            if (fw>14) {
                g2.setColor(new Color(0,0,0,80));
                int mid=y+ROW_H/2;
                if (f.strand.equals("+")) {
                    int ax=x1+fw-8;
                    g2.fillPolygon(new int[]{ax,ax+6,ax},new int[]{mid-4,mid,mid+4},3);
                } else if (f.strand.equals("-")) {
                    int ax=x1+8;
                    g2.fillPolygon(new int[]{ax,ax-6,ax},new int[]{mid-4,mid,mid+4},3);
                }
            }

            if (fw>30) {
                String lbl = f.name.length()>18 ? f.name.substring(0,17)+"…" : f.name;
                int lw=fm.stringWidth(lbl);
                if (lw+4<fw) {
                    g2.setColor(new Color(0,0,0,180));
                    g2.drawString(lbl, x1+(fw-lw)/2, y+ROW_H-5);
                }
            }

            g2.setColor(col.darker()); g2.drawRoundRect(x1,y,fw,ROW_H,6,6);
            hits.add(new FR(f, new Rectangle(x1,y,fw,ROW_H)));
        }
    }
}
