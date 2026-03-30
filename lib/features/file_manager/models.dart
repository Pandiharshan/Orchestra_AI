import 'package:flutter/material.dart';

enum FileType {
  folder,
  image,
  document,
  code,
  archive,
  video,
  audio,
  pdf,
}

class FileItem {
  final int id;
  final String name;
  final FileType type;
  final String size;
  final DateTime modified;
  final String path;

  const FileItem({
    required this.id,
    required this.name,
    required this.type,
    required this.size,
    required this.modified,
    required this.path,
  });
}

class FolderNode {
  final String name;
  final IconData icon;
  final List<FolderNode> children;
  bool expanded;

  FolderNode({
    required this.name,
    required this.icon,
    this.children = const [],
    this.expanded = false,
  });
}

// ── Sample Data ───────────────────────────────────────────────────────────────

final List<FileItem> sampleFiles = [
  FileItem(id: 1, name: "Design Assets", type: FileType.folder, size: "—", modified: DateTime.now().subtract(const Duration(days: 1)), path: "/Projects/Design Assets"),
  FileItem(id: 2, name: "hero-illustration.png", type: FileType.image, size: "4.2 MB", modified: DateTime.now().subtract(const Duration(hours: 3)), path: "/Projects/hero-illustration.png"),
  FileItem(id: 3, name: "README.md", type: FileType.document, size: "12 KB", modified: DateTime.now().subtract(const Duration(hours: 6)), path: "/Projects/README.md"),
  FileItem(id: 4, name: "main.kt", type: FileType.code, size: "8.7 KB", modified: DateTime.now().subtract(const Duration(days: 2)), path: "/Projects/main.kt"),
  FileItem(id: 5, name: "release-v2.zip", type: FileType.archive, size: "128 MB", modified: DateTime.now().subtract(const Duration(days: 3)), path: "/Projects/release-v2.zip"),
  FileItem(id: 6, name: "demo-reel.mp4", type: FileType.video, size: "740 MB", modified: DateTime.now().subtract(const Duration(days: 5)), path: "/Projects/demo-reel.mp4"),
  FileItem(id: 7, name: "ambient-loop.wav", type: FileType.audio, size: "22 MB", modified: DateTime.now().subtract(const Duration(days: 7)), path: "/Projects/ambient-loop.wav"),
  FileItem(id: 8, name: "spec-sheet.pdf", type: FileType.pdf, size: "1.8 MB", modified: DateTime.now().subtract(const Duration(minutes: 30)), path: "/Projects/spec-sheet.pdf"),
  FileItem(id: 9, name: "Components", type: FileType.folder, size: "—", modified: DateTime.now().subtract(const Duration(days: 10)), path: "/Projects/Components"),
  FileItem(id: 10, name: "build.gradle.kts", type: FileType.code, size: "3.1 KB", modified: DateTime.now().subtract(const Duration(days: 4)), path: "/Projects/build.gradle.kts"),
  FileItem(id: 11, name: "mockup-v3.png", type: FileType.image, size: "6.5 MB", modified: DateTime.now().subtract(const Duration(hours: 1)), path: "/Projects/mockup-v3.png"),
  FileItem(id: 12, name: "CHANGELOG.md", type: FileType.document, size: "5.4 KB", modified: DateTime.now().subtract(const Duration(days: 6)), path: "/Projects/CHANGELOG.md"),
];

final List<FolderNode> folderTree = [
  FolderNode(name: "Home", icon: Icons.home),
  FolderNode(name: "Projects", icon: Icons.folder_special, children: [
    FolderNode(name: "Design Assets", icon: Icons.folder),
    FolderNode(name: "Components", icon: Icons.folder),
    FolderNode(name: "Releases", icon: Icons.folder),
  ]),
  FolderNode(name: "Documents", icon: Icons.description),
  FolderNode(name: "Downloads", icon: Icons.download),
  FolderNode(name: "Pictures", icon: Icons.image),
  FolderNode(name: "Trash", icon: Icons.delete),
];
