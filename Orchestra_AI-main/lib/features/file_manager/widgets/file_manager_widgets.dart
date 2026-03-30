import 'package:flutter/material.dart';
import '../theme.dart';
import '../models.dart';
// Note: If you have intel (intl) package, import it, else we format date manually.

class TypeInfo {
  final Color color;
  final String label;
  final IconData icon;

  const TypeInfo(this.color, this.label, this.icon);
}

TypeInfo getFileTypeInfo(FileType type) {
  switch (type) {
    case FileType.folder:
      return const TypeInfo(FileManagerColors.accentBlue, "DIR", Icons.folder);
    case FileType.image:
      return const TypeInfo(FileManagerColors.accentRose, "IMG", Icons.image);
    case FileType.document:
      return const TypeInfo(FileManagerColors.accentAmber, "DOC", Icons.description);
    case FileType.code:
      return const TypeInfo(FileManagerColors.accentLilac, "CODE", Icons.code);
    case FileType.archive:
      return const TypeInfo(FileManagerColors.accentTeal, "ZIP", Icons.archive);
    case FileType.video:
      return const TypeInfo(FileManagerColors.accentRose, "VID", Icons.video_file);
    case FileType.audio:
      return const TypeInfo(FileManagerColors.accentTeal, "AUD", Icons.audio_file);
    case FileType.pdf:
      return const TypeInfo(FileManagerColors.accentAmber, "PDF", Icons.picture_as_pdf);
  }
}

// ── Drop Overlay ──────────────────────────────────────────────────────────────
class DropOverlay extends StatelessWidget {
  const DropOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FileManagerColors.dropZoneBg,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: FileManagerColors.accentBlue.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: FileManagerColors.accentBlue.withValues(alpha: 0.4), width: 1.5),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.upload, color: FileManagerColors.accentBlue, size: 36),
          ),
          const SizedBox(height: 16),
          const Text("Drop files to upload", style: TextStyle(color: FileManagerColors.accentBlue, fontSize: 16, fontWeight: FontWeight.w500)),
          const Text("Release to add to current folder", style: TextStyle(color: FileManagerColors.textMid, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, color: FileManagerColors.textLow, size: 40),
          SizedBox(height: 12),
          Text("No files found", style: TextStyle(color: FileManagerColors.textMid, fontSize: 14)),
          Text("Try a different search term", style: TextStyle(color: FileManagerColors.textLow, fontSize: 12)),
        ],
      ),
    );
  }
}

// ── File Grid ─────────────────────────────────────────────────────────────────
class FileGrid extends StatelessWidget {
  final List<FileItem> files;
  final FileItem? selectedFile;
  final ValueChanged<FileItem> onSelect;

  const FileGrid({
    super.key,
    required this.files,
    this.selectedFile,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        final isSelected = file.id == selectedFile?.id;
        final typeInfo = getFileTypeInfo(file.type);

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => onSelect(file),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? FileManagerColors.bgSelected : FileManagerColors.bgPanel,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? FileManagerColors.accentBlue : FileManagerColors.bdLine,
                  width: isSelected ? 1 : 0.5,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: typeInfo.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Icon(typeInfo.icon, color: typeInfo.color, size: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    file.name,
                    style: const TextStyle(color: FileManagerColors.textHigh, fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ── File List (Table View) ────────────────────────────────────────────────────
class FileList extends StatelessWidget {
  final List<FileItem> files;
  final FileItem? selectedFile;
  final ValueChanged<FileItem> onSelect;

  const FileList({
    super.key,
    required this.files,
    this.selectedFile,
    required this.onSelect,
  });

  String _formatDate(DateTime date) {
    // Simple mock formatting since intl is absent
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final m = months[date.month - 1];
    final hr = date.hour.toString().padLeft(2, '0');
    final mn = date.minute.toString().padLeft(2, '0');
    return "$m ${date.day}, ${date.year}  $hr:$mn";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header Row
        Container(
          color: FileManagerColors.bgPanel,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: FileManagerColors.bdLine, width: 0.5)),
          ),
          child: Row(
            children: const [
              Expanded(flex: 25, child: TableHeader(label: "Name")),
              Expanded(flex: 10, child: TableHeader(label: "Type")),
              Expanded(flex: 8, child: TableHeader(label: "Size")),
              Expanded(flex: 14, child: TableHeader(label: "Date Modified")),
            ],
          ),
        ),
        // List Body
        Expanded(
          child: files.isEmpty
              ? const EmptyState()
              : ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    final isSelected = file.id == selectedFile?.id;
                    final isEven = index % 2 == 0;
                    final bg = isSelected ? FileManagerColors.bgSelected : (isEven ? FileManagerColors.bgCard : FileManagerColors.bgCard.withValues(alpha: 0.7));
                    final typeInfo = getFileTypeInfo(file.type);

                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => onSelect(file),
                        child: Container(
                          decoration: BoxDecoration(
                            color: bg,
                            border: isSelected
                                ? const Border(left: BorderSide(color: FileManagerColors.accentBlue, width: 2.5))
                                : null,
                          ),
                          padding: EdgeInsets.only(left: isSelected ? 17.5 : 20, right: 20, top: 10, bottom: 10),
                          child: Row(
                            children: [
                              // Name
                              Expanded(
                                flex: 25,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: typeInfo.color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      alignment: Alignment.center,
                                      child: Icon(typeInfo.icon, color: typeInfo.color, size: 14),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        file.name,
                                        style: TextStyle(
                                          color: isSelected ? FileManagerColors.textHigh : FileManagerColors.textHigh.withValues(alpha: 0.9),
                                          fontSize: 13,
                                          fontWeight: file.type == FileType.folder ? FontWeight.w500 : FontWeight.normal,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Type Badge
                              Expanded(
                                flex: 10,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: typeInfo.color.withValues(alpha: 0.10),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: typeInfo.color.withValues(alpha: 0.25), width: 0.5),
                                    ),
                                    child: Text(
                                      typeInfo.label,
                                      style: TextStyle(color: typeInfo.color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                    ),
                                  ),
                                ),
                              ),
                              // Size
                              Expanded(
                                flex: 8,
                                child: Text(
                                  file.size,
                                  style: const TextStyle(color: FileManagerColors.textMid, fontSize: 12),
                                ),
                              ),
                              // Date
                              Expanded(
                                flex: 14,
                                child: Text(
                                  _formatDate(file.modified),
                                  style: const TextStyle(color: FileManagerColors.textMid, fontSize: 11.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class TableHeader extends StatelessWidget {
  final String label;

  const TableHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: FileManagerColors.textLow,
        fontSize: 10.5,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
      ),
    );
  }
}
