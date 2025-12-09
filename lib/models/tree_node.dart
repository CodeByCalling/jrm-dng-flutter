class TreeNode {
  final String name;
  final String role;
  final String status;
  final List<TreeNode> children;

  TreeNode({
    required this.name,
    required this.role,
    this.status = 'Phase 1',
    this.children = const [],
  });
}
