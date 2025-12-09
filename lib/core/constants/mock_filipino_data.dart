import 'package:jrm_dng_flutter/models/tree_node.dart';

final List<TreeNode> mockFilipinoTree = [
  TreeNode(
    name: 'Kuya Bong',
    role: 'Leader',
    status: 'Phase 3',
    children: [
      // Gen 1: Jojo
      TreeNode(
        name: 'Jojo',
        role: 'Disciple',
        status: 'Phase 2',
        children: [
          // Gen 2 (Jojo's Disciples)
          TreeNode(
            name: 'Lito',
            role: 'Disciple',
            status: 'Phase 1',
            children: [
              TreeNode(name: 'Inday', role: 'Disciple', status: 'Phase 1'),
              TreeNode(name: 'Bebot', role: 'Disciple', status: 'Phase 1'),
            ],
          ),
          TreeNode(
            name: 'Chito',
            role: 'Disciple',
            status: 'Phase 1',
            children: [
              TreeNode(name: 'Totoy', role: 'Disciple', status: 'Phase 1'),
              TreeNode(name: 'Nene', role: 'Disciple', status: 'Phase 1'),
            ],
          ),
          TreeNode(
            name: 'Cherry',
            role: 'Disciple',
            status: 'Phase 1',
            children: [
              TreeNode(name: 'Bong', role: 'Disciple', status: 'Phase 1'),
              TreeNode(name: 'Grace', role: 'Disciple', status: 'Phase 1'),
            ],
          ),
        ],
      ),
      // Gen 1: Marites
      TreeNode(
        name: 'Marites',
        role: 'Disciple',
        status: 'Phase 2',
        children: [
          // Gen 2 (Marites' Disciples)
          TreeNode(
            name: 'Angel',
            role: 'Disciple',
            status: 'Phase 1',
            children: [
              TreeNode(name: 'Bea', role: 'Disciple', status: 'Phase 1'),
              TreeNode(name: 'John', role: 'Disciple', status: 'Phase 1'),
            ],
          ),
          TreeNode(
            name: 'Manny',
            role: 'Disciple',
            status: 'Phase 1',
            children: [
              TreeNode(name: 'Mark', role: 'Disciple', status: 'Phase 1'),
              TreeNode(name: 'Paul', role: 'Disciple', status: 'Phase 1'),
            ],
          ),
          TreeNode(
            name: 'Sarah',
            role: 'Disciple',
            status: 'Phase 1',
            children: [
              TreeNode(name: 'Peter', role: 'Disciple', status: 'Phase 1'),
              TreeNode(name: 'James', role: 'Disciple', status: 'Phase 1'),
            ],
          ),
        ],
      ),
      // Gen 1: Dingdong
      TreeNode(
        name: 'Dingdong',
        role: 'Disciple',
        status: 'Phase 2',
        children: [
          // Gen 2 (Dingdong's Disciples)
          TreeNode(
            name: 'Romy',
            role: 'Disciple',
            status: 'Phase 1',
            children: [
              TreeNode(name: 'Mary', role: 'Disciple', status: 'Phase 1'),
              TreeNode(name: 'Joy', role: 'Disciple', status: 'Phase 1'),
            ],
          ),
          TreeNode(
            name: 'Jun',
            role: 'Disciple',
            status: 'Phase 1',
            children: [
              TreeNode(name: 'Hope', role: 'Disciple', status: 'Phase 1'),
              TreeNode(name: 'Faith', role: 'Disciple', status: 'Phase 1'),
            ],
          ),
          TreeNode(
            name: 'Boyet',
            role: 'Disciple',
            status: 'Phase 1',
            children: [
              TreeNode(name: 'Ruth', role: 'Disciple', status: 'Phase 1'),
              TreeNode(name: 'Esther', role: 'Disciple', status: 'Phase 1'),
            ],
          ),
        ],
      ),
    ],
  ),
];
