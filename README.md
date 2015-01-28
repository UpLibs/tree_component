# tree_component
Dart Tree component

Independent component to be used in .dart code.
He creates a Tree Component, has listeners, expandable and checkboxes in nodes.


This lib is Under construction!


# Example

```dart

void main() {
  Element el = querySelector("#sample_container_id"); //Div in html
  build_tree(el);
}

build_tree(Element parentElement){
  var root = new TreeNode.root("the-root") ;
  
  root.listener = new RootNodeListener();
  
  root.createChild('sub1-a')
  ..createChild('sub2-a')
  ..createChild('sub2-b')
  ;
  
  root.createChild('sub1-b')
  ..createChild('sub2-a')
  ;
  
  var tree = new TreeComponent(root) ;
  
  tree.buildAt(parentElement);
}

class RootNodeListener extends TreeNodeListener{
  
  @override
  onCheckAction(TreeNode node) {
    window.alert('onCheckAction');
  }

  @override
  onClickAction(TreeNode node) {
    window.alert('onClickAction');
  }

  @override
  onExpandAction(TreeNode node) {
    window.alert('onExpandAction');
  }
  
}

```