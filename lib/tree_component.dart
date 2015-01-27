library tree_component;

import 'dart:html' ;

main(){
   
  /*
    
  var root = new TreeNode.root("the-root") ;
  
  root.createChild('sub1-a')
  ..createChild('sub2-a')
  ..createChild('sub2-b')
  ;
  
  root.createChild('sub1-b')
  ..createChild('sub2-a')
  ;
  
  var tree = new TreeComponent(root) ;
  
  tree.buildAt(parentElement)
   
  */
  
}

class TreeComponent {

  TreeNode _root ;
  
  TreeComponent(this._root) ;
  
  Element _parentElement ;
  
  void buildAt(Element parentElement) {
    if (this._parentElement != null) remove() ;
    
    this._parentElement = parentElement ;
    
    _buildTree( parentElement , _root ) ;
  }
  
  void _buildTree(Element parentElement, TreeNode node) {
    
    UListElement elem = new UListElement() ;
    
    elem.style.listStyleType = 'none' ;
    
    elem.children.add(
        new LIElement()
        ..text = node.name
    ) ;
    
    parentElement.children.add(elem) ;
    
    for ( var subNode in node._children ) {
      _buildTree(elem , subNode) ;
    }
    
  }
  
  
  void remove() {
    if (this._parentElement == null) return ;
  }
  

}

class TreeNode {
  String name;
  Map properties;
  
  TreeNode _parent;
  List<TreeNode> _children = [];
  
  bool _expanded = false;
  
  TreeNode.root(this.name, [this.properties , this._expanded = false]) {
    checkInit() ;
  }
  
  TreeNode.node(this._parent, this.name, [this.properties, this._expanded = false]) {
    checkInit() ;
  }
  
  void checkInit() {
    if ( this.properties == null ) this.properties = {} ; 
  }
  
  bool get isRoot => _parent == null ;
  bool get isParent => hasChildren ;
  bool get hasChildren => _children.isNotEmpty ;
  bool get isExpanded => _expanded ;
  
  List<TreeNode> get children => _children;
  
  TreeNode get parent => _parent;
  
  TreeNode getRoot() {
    TreeNode cursor = this ;
    do {
      if (cursor.isRoot) return cursor ;
      cursor = cursor.parent ;
    }
    while (cursor != null) ;
    
    throw new StateError("Invalid tree structure") ;
  }
  
  TreeNode createChild(String name, [Map properties, bool expanded]) {
    var child = new TreeNode.node(this, name, properties, expanded) ;
    this._children.add(child) ;
    return child ;
  }
  
  /////////
  
  TreeNodeListener listener ;

  /////////
  
  Element _componentElement ;
  
  /////////
  
  Map<String, Object> toJson() => {"data": properties};
  
}

abstract class TreeNodeListener {
  
  onClickListenerAction(TreeNode node);
  
}
