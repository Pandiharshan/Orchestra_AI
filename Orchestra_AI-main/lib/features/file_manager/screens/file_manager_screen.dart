import 'package:flutter/material.dart';
import '../theme.dart';
import '../models.dart';
import '../widgets/file_manager_widgets.dart';

class FileManagerScreen extends StatefulWidget {
  const FileManagerScreen({super.key});

  @override
  State<FileManagerScreen> createState() => _FileManagerScreenState();
}

class _FileManagerScreenState extends State<FileManagerScreen> {
  // View State
  bool isGridView = false;
  String currentPath = "/Projects/Design Assets";
  String searchQuery = "";

  // Selection
  FileItem? selectedItem;
  String activeFolder = "Design Assets";

  // Data
  final List<FolderNode> stateFolderTree = folderTree;
  
  List<FileItem> get filteredFiles {
    if (searchQuery.isEmpty) return sampleFiles;
    return sampleFiles.where((f) => f.name.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  }

  void toggleFolder(FolderNode node) {
    setState(() {
      node.expanded = !node.expanded;
    });
  }

  void selectFolder(String pathName) {
    setState(() {
      activeFolder = pathName;
      currentPath = "/Projects/$pathName"; // Mock path logic
      // Ideally update path and item lists based on real logic
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FileManagerColors.bgBase,
      body: Row(
        children: [
          // Left Sidebar (Nav Pane)
          SizedBox(
            width: 240,
            child: Container(
              color: FileManagerColors.bgPanel,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   Container(
                    height: 56, // MacOS traffic light spacing + header
                    padding: const EdgeInsets.only(left: 16, bottom: 8, top: 20),
                    alignment: Alignment.centerLeft,
                    child: const Text("Files", style: TextStyle(color: FileManagerColors.textHigh, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 1, thickness: 1, color: FileManagerColors.bdLine),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        children: stateFolderTree.map((node) => _buildTreeNode(node, 0)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Divider
          Container(width: 1, color: FileManagerColors.bdLine),

          // Main View (Toolbar + Content)
          Expanded(
            child: Column(
              children: [
                // Toolbar
                Container(
                  height: 56,
                  color: FileManagerColors.bgPanel,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Nav Buttons
                      _IconButton(icon: Icons.chevron_left, onPressed: () {}),
                      const SizedBox(width: 8),
                      _IconButton(icon: Icons.chevron_right, onPressed: () {}),
                      const SizedBox(width: 16),
                      
                      // Path Bar
                      Expanded(
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: FileManagerColors.bgCard,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: FileManagerColors.bdLine),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.folder, color: FileManagerColors.accentBlue, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(currentPath, style: const TextStyle(color: FileManagerColors.textMid, fontSize: 13)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Search
                      Container(
                        width: 200,
                        height: 32,
                        decoration: BoxDecoration(
                          color: FileManagerColors.bgCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: FileManagerColors.bdMid),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            const Icon(Icons.search, color: FileManagerColors.textLow, size: 14),
                            const SizedBox(width: 6),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(color: FileManagerColors.textHigh, fontSize: 12),
                                decoration: const InputDecoration(
                                  hintText: "Search...",
                                  hintStyle: TextStyle(color: FileManagerColors.textLow, fontSize: 12),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    searchQuery = val;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // View Toggles
                      Container(
                        height: 28,
                        decoration: BoxDecoration(
                          color: FileManagerColors.bdLine,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ViewToggleBtn(
                              icon: Icons.list,
                              active: !isGridView,
                              onPressed: () => setState(() => isGridView = false),
                            ),
                            _ViewToggleBtn(
                              icon: Icons.grid_view,
                              active: isGridView,
                              onPressed: () => setState(() => isGridView = true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Toolbar Divider
                Container(height: 1, color: FileManagerColors.bdLine),
                
                // Content Area
                Expanded(
                  child: Container(
                    color: FileManagerColors.bgBase,
                    child: isGridView 
                        ? FileGrid(files: filteredFiles, selectedFile: selectedItem, onSelect: (f) => setState(() => selectedItem = f))
                        : FileList(files: filteredFiles, selectedFile: selectedItem, onSelect: (f) => setState(() => selectedItem = f)),
                  ),
                ),
              ],
            ),
          ),
          
          // Divider
          Container(width: 1, color: FileManagerColors.bdLine),
          
          // Right Sidebar (Preview Pane)
          if (selectedItem != null)
            SizedBox(
              width: 280,
              child: Container(
                color: FileManagerColors.bgPanel,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: _IconButton(
                        icon: Icons.close,
                        onPressed: () => setState(() => selectedItem = null),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Preview Image / Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: getFileTypeInfo(selectedItem!.type).color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.center,
                      child: Icon(getFileTypeInfo(selectedItem!.type).icon, size: 64, color: getFileTypeInfo(selectedItem!.type).color),
                    ),
                    const SizedBox(height: 24),
                    
                    Text(
                      selectedItem!.name,
                      style: const TextStyle(color: FileManagerColors.textHigh, fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      selectedItem!.size,
                      style: const TextStyle(color: FileManagerColors.textMid, fontSize: 13),
                    ),
                    
                    const SizedBox(height: 32),
                    const Divider(color: FileManagerColors.bdLine, height: 1),
                    const SizedBox(height: 20),
                    
                    // Meta details
                    _PreviewMetaRow(label: "Type", value: getFileTypeInfo(selectedItem!.type).label),
                    _PreviewMetaRow(label: "Modified", value: selectedItem!.modified.toString().substring(0, 16)), // Simplistic date for preview
                    _PreviewMetaRow(label: "Path", value: selectedItem!.path.split('/').last), // simplistic truncation
                    
                    const Spacer(),
                    
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: FileManagerColors.accentBlue.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: FileManagerColors.accentBlue.withValues(alpha: 0.5)),
                              ),
                              alignment: Alignment.center,
                              child: const Text("Open", style: TextStyle(color: FileManagerColors.accentBlue, fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                         Expanded(
                          child: InkWell(
                            onTap: () {},
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: FileManagerColors.bgCard,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: FileManagerColors.bdMid),
                              ),
                              alignment: Alignment.center,
                              child: const Text("Share", style: TextStyle(color: FileManagerColors.textHigh, fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTreeNode(FolderNode node, int depth) {
    bool isActive = activeFolder == node.name;
    bool hasChildren = node.children.isNotEmpty;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            selectFolder(node.name);
            if (hasChildren) toggleFolder(node);
          },
          child: Container(
            padding: EdgeInsets.only(left: 16.0 + (depth * 16.0), right: 16.0, top: 6, bottom: 6),
            decoration: BoxDecoration(
              color: isActive ? FileManagerColors.bgSelected : Colors.transparent,
              border: Border(left: BorderSide(color: isActive ? FileManagerColors.accentBlue : Colors.transparent, width: 3)),
            ),
            child: Row(
              children: [
                if (hasChildren) ...[
                   Icon(node.expanded ? Icons.arrow_drop_down : Icons.arrow_right, color: FileManagerColors.textMid, size: 16),
                ] else ...[
                   const SizedBox(width: 16),
                ],
                const SizedBox(width: 4),
                Icon(node.icon, color: isActive ? FileManagerColors.accentBlue : FileManagerColors.textMid, size: 16),
                const SizedBox(width: 8),
                Text(
                  node.name,
                  style: TextStyle(
                    color: isActive ? FileManagerColors.textHigh : FileManagerColors.textMid,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (node.expanded && hasChildren) ...[
          for (var child in node.children) _buildTreeNode(child, depth + 1),
        ],
      ],
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _IconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(icon, color: FileManagerColors.textMid, size: 18),
      ),
    );
  }
}

class _ViewToggleBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;

  const _ViewToggleBtn({required this.icon, required this.active, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 28,
        height: 24,
        decoration: BoxDecoration(
          color: active ? FileManagerColors.textLow : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: active ? FileManagerColors.textHigh : FileManagerColors.textMid, size: 14),
      ),
    );
  }
}

class _PreviewMetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _PreviewMetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 70, child: Text(label, style: const TextStyle(color: FileManagerColors.textLow, fontSize: 12, fontWeight: FontWeight.w500))),
          Expanded(child: Text(value, style: const TextStyle(color: FileManagerColors.textHigh, fontSize: 12))),
        ],
      ),
    );
  }
}
