# tree_component
Dart Tree component

Independent component to be used in .dart code.
He creates a Tree Component, has listeners, expandable and checkboxes in nodes.


This lib is Under construction!


# Example

```dart

void main() {
  Element el = querySelector("#sample_container_id");
  build_tree(el);
}

build_tree(Element parentElement){
  var root = new TreeNode.root("the-root") ;
  
  root.listener = new RootNodeListener();
  
  Map prop = new Map();
  prop['color'] = '#666999';
  
  Map prop2 = new Map();
  prop2['color'] = '#666666';
    
  Map prop3 = new Map();
  prop3['color'] = '#123456';
      
  Map prop4 = new Map();
  prop4['color'] = '#562310';
        
  Map prop5 = new Map();
  prop5['color'] = '#010101';
          
  Map prop6 = new Map();
  prop6['color'] = '#963258';
  
  var treeNode = root.createChild('sub1-a')
//  ..createChild('sub2-a')
//  ..createChild('sub2-b')
  ;
  
  treeNode.listener = new RootNodeListener();
  
  treeNode.createChild('sub2-c').properties=prop;
  treeNode.createChild('sub2-d').properties=prop2;
  treeNode.createChild('sub2-e').properties=prop3;
  treeNode.createChild('sub2-f').properties=prop4;
  treeNode.createChild('sub2-g').properties=prop5;
  treeNode.createChild('sub2-h').properties=prop6;

  treeNode.properties = prop;
  
  root.createChild('sub1-b')
  ..createChild('sub2-a') ;
  
  var tree = new TreeComponent(root) ;
  
  tree.buildAt(parentElement);
}


class RootNodeListener extends TreeNodeListener{
  
  @override
  onCheckAction(TreeNode node) {
    // TODO: implement onCheckAction
    window.alert('onCheckAction '+node.isChecked.toString());
  }

  @override
  onClickAction(TreeNode node) {
    // TODO: implement onClickAction
    window.alert('onClickAction '+node.name);
  }

  @override
  onExpandAction(TreeNode node) {
    // TODO: implement onExpandAction
    window.alert('onExpandAction '+node.isExpanded.toString());
  }
  
}

```

Result:

![Alt text](https://lh4.googleusercontent.com/Ac7_f1DAh6t9Xqw-LEl4IJkVEflZ5YkVFLsNsYdUU7QVDh3gfkyE6gpwBg_VEdSiIEqCbQ=w1511-h669)