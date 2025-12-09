import 'package:flutter/material.dart';
import 'package:jrm_dng_flutter/models/tree_node.dart';

class DiscipleshipTreeWidget extends StatefulWidget {
  final TreeNode rootNode;

  const DiscipleshipTreeWidget({super.key, required this.rootNode});

  @override
  State<DiscipleshipTreeWidget> createState() => _DiscipleshipTreeWidgetState();
}

class _DiscipleshipTreeWidgetState extends State<DiscipleshipTreeWidget> {
  // Config
  static const double nodeSize = 60.0;
  static const double verticalSpacing = 80.0;
  static const double horizontalSpacing = 20.0;

  @override
  Widget build(BuildContext context) {
    // 1. Calculate the layout
    final layout = _calculateLayout(widget.rootNode);
    final size = layout.size;
    final nodePositions = layout.positions;

    // 2. Wrap in InteractiveViewer for zoom/pan
    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(100),
      minScale: 0.1,
      maxScale: 4.0,
      constrained: false, // Allow unbounded canvas calculate
      child: Center(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              // Layer 1: Lines
              CustomPaint(
                size: size,
                painter: _TreeLinePainter(
                  nodePositions: nodePositions,
                  nodeSize: nodeSize,
                ),
              ),
              // Layer 2: Nodes
              ...nodePositions.entries.map((entry) {
                final node = entry.key;
                final pos = entry.value;
                return Positioned(
                  left: pos.dx,
                  top: pos.dy,
                  child: _buildNodeWidget(node),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNodeWidget(TreeNode node) {
    return GestureDetector(
      onTap: () => _showNodeDetails(node),
      child: Container(
        width: nodeSize,
        height: nodeSize,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          node.name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    );
  }

  void _showNodeDetails(TreeNode node) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                node.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                node.role,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 16),
              if (node.children.isNotEmpty)
                Text(
                  'Mentoring ${node.children.length} disciples',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
            ],
          ),
        );
      },
    );
  }

  // --- Layout Algorithm ---

  _TreeLayout _calculateLayout(TreeNode root) {
    // 1. Calculate widths recursively
    final nodeWidths = <TreeNode, double>{};
    _calculateRequiredWidth(root, nodeWidths);

    // 2. Assign positions recursively
    final positions = <TreeNode, Offset>{};
    // Center the root horizontally in its required width
    // Actually, we can just start at 0,0 relative, then shift everything if needed?
    // Better: Helper function that returns the subtree's bounding box center
    _assignPositions(root, 0, 0, positions, nodeWidths);

    // 3. Determine total size
    double maxX = 0;
    double maxY = 0;
    for (final pos in positions.values) {
      if (pos.dx > maxX) maxX = pos.dx;
      if (pos.dy > maxY) maxY = pos.dy;
    }

    return _TreeLayout(
      size: Size(maxX + nodeSize, maxY + nodeSize),
      positions: positions,
    );
  }

  // Post-order traversal to calculate width needed for each subtree
  double _calculateRequiredWidth(
      TreeNode node, Map<TreeNode, double> nodeWidths) {
    if (node.children.isEmpty) {
      nodeWidths[node] = nodeSize + horizontalSpacing;
      return nodeSize + horizontalSpacing;
    }

    double width = 0;
    for (final child in node.children) {
      width += _calculateRequiredWidth(child, nodeWidths);
    }
    nodeWidths[node] = width;
    return width;
  }

  // Pre-order traversal to assign positions
  // xOffset: The starting X coordinate for this node's subtree allocation range
  void _assignPositions(TreeNode node, double xOffset, double yLevel,
      Map<TreeNode, Offset> positions, Map<TreeNode, double> nodeWidths) {
    
    // The node acts as a parent. It should be centered above its children.
    // The children occupy the range [xOffset, xOffset + childrenWidth]
    
    double myX;
    
    if (node.children.isEmpty) {
      // If leaf, just place it in the center of its 'slot' (which is nodeSize+spacing)
      // Actually, we allocated 'nodeSize + horizontalSpacing' for it.
      // So center at xOffset + (allocated/2) - (nodeSize/2)
      // Simplifying: let's just use top-left coordinates for logic and center visually? 
      // Let's stick to placing the top-left corner of the node widget.
      
      double allocated = nodeWidths[node]!;
      myX = xOffset + (allocated - nodeSize) / 2;
    } else {
       // Parent: Recursively position children
       double currentChildX = xOffset;
       List<double> childCenters = [];
       
       for (final child in node.children) {
         double childWidth = nodeWidths[child]!;
         _assignPositions(child, currentChildX, yLevel + 1, positions, nodeWidths);
         
         // Find where the child was actually placed (center of child)
         // Child pos in map is top-left.
         Offset childPos = positions[child]!;
         childCenters.add(childPos.dx + nodeSize / 2);
         
         currentChildX += childWidth;
       }
       
       // Position self at average of children's centers
       double avgChildCenter = childCenters.reduce((a, b) => a + b) / childCenters.length;
       myX = avgChildCenter - (nodeSize / 2);
    }

    positions[node] = Offset(myX, yLevel * (nodeSize + verticalSpacing));
  }
}

class _TreeLayout {
  final Size size;
  final Map<TreeNode, Offset> positions;

  _TreeLayout({required this.size, required this.positions});
}

class _TreeLinePainter extends CustomPainter {
  final Map<TreeNode, Offset> nodePositions;
  final double nodeSize;
  final Paint linePaint;

  _TreeLinePainter({required this.nodePositions, required this.nodeSize})
      : linePaint = Paint()
          ..color = Colors.grey
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    nodePositions.forEach((node, pos) {
      final parentCenter = Offset(pos.dx + nodeSize / 2, pos.dy + nodeSize / 2);
      final bottomOfParent = Offset(parentCenter.dx, pos.dy + nodeSize);

      for (final child in node.children) {
        if (nodePositions.containsKey(child)) {
          final childPos = nodePositions[child]!;
          final topOfChild = Offset(childPos.dx + nodeSize / 2, childPos.dy);

          // Draw bezier curve
          final path = Path();
          path.moveTo(bottomOfParent.dx, bottomOfParent.dy);
          path.cubicTo(
            bottomOfParent.dx, bottomOfParent.dy + 20, // Control point 1
            topOfChild.dx, topOfChild.dy - 20, // Control point 2
            topOfChild.dx, topOfChild.dy,
          );
          
          canvas.drawPath(path, linePaint);
        }
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
