library tree_component;

class Tree {
 
}

class TreeNode {
//  String type;
  List data;
  List<TreeNode> _children = [];
  TreeNode _parent;
  bool expanded = false;
  bool isParent = false;
  
  TreeNode(this.data , TreeNode parent) {
    if (parent != null) {
      this.parent = parent;
      parent.isParent = true;
    }
  }
  
  List<TreeNode> get children => _children;
  
  TreeNode get parent => _parent;
  
  set parent(TreeNode parent) {
    _parent = parent;
    parent.isParent = true;
    
    if (!parent.children.contains(this)) {
      parent.children.add(this);
    }
  }
  
  Map<String, Object> toJson() => {"data": data};
  
}

abstract class TreeNodeListener extends TreeNode{
  
  TreeNodeListener(List data, TreeNode parent) : super(data, parent);
  
  onClickListenerAction();
  
}