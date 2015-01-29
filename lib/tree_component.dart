library tree_component;

import 'dart:html';

class TreeComponent {

  TreeNode _root;

  TreeComponent(this._root);

  Element _parentElement;

  void buildAt(Element parentElement,[int margin = 0]) {
    if (this._parentElement != null) remove();

    this._parentElement = parentElement;

    _buildNode(parentElement, _root , margin);
  }

  void _buildNode(Element parentElement, TreeNode node,[int margin]) {

    if(margin == null) {
      margin = -10;
    }
    UListElement elem = new UListElement();
    elem.style.listStyleType = 'none';
    elem.style.marginLeft = margin.toString()+"px";

    node._treeElement = elem;

    var nodeComponent = new TreeNodeComponent(this, node);
    node._component = nodeComponent;

    elem.children.add(nodeComponent.element);

    parentElement.children.add(elem);

    _buildNodeChildren(node);

  }

  void _buildNodeChildren(TreeNode node) {

    if (node.isExpanded) {

      for (var subNode in node._children) {
        _buildNode(node._treeElement, subNode);
      }

    }

  }

  void remove() {
    if (this._parentElement == null) return;

    _removeNode(_root);
  }

  void _removeNode(TreeNode node) {

    _removeNodeChildren(node);

    if (node._component != null) {
      node._component.remove();
      node._component = null;
    }

  }

  void _removeNodeChildren(TreeNode node) {

    for (var subNode in node._children) {
      _removeNode(subNode);
    }

  }

}


class TreeNodeComponent {

  TreeComponent _treeComponent;

  TreeNode _node;
  LIElement _element;

  TreeNodeComponent(this._treeComponent, this._node) {
    _build();
  }

  Element get element => _element;

  void _build() {
    this._element = new LIElement();
    buildContent();
  }

  void buildContent() {

    for (var child in new List.from(_element.children)) {
      child.remove();
    }

    CheckboxInputElement checkBox = new CheckboxInputElement();
    checkBox.checked = _node.isChecked;

    checkBox.onClick.listen((_) {
      if (_node.isChecked) {
        _node.checked = false;
      } else {
        _node.checked = true;
      }
      
      if(_node.listener != null)
      _node.listener.onCheckAction(_node);
    });

    if (_node.hasChildren) {

      ImageElement imgArrow = new ImageElement()
      ..src = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAAg0lEQVQ"+
              "4jcXPrQ0CQRRF4Y8fh0LRwVIENVALLdAEDdAFBrsSj1sawIJhMWxCXibhZRB7kytGnDP3MXZm4X1FgxaPGmH/6R27wgdpwdALNv8I"+
              "erxwxKpWEM+a1wqGnr+BaWZWyKR2wQ3bX/YS+MQei8y8CJ+wzoBR0GXmltLhgGUNPE7e4DU8I8utB5cAAAAASUVORK5CYII=";

      if (_node.isExpanded) {

        imgArrow.src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAlwSFl"+
                "zAAALEwAACxMBAJqcGAAABCRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6"+
                "eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1ze"+
                "W50YXgtbnMjIj4KICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlmZj0iaHR0cDovL25zLm"+
                "Fkb2JlLmNvbS90aWZmLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOmV4aWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20vZXhpZi8xLjAvIgogICAgICA"+
                "gICAgICB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0cDovL25z"+
                "LmFkb2JlLmNvbS94YXAvMS4wLyI+CiAgICAgICAgIDx0aWZmOlJlc29sdXRpb25Vbml0PjI8L3RpZmY6UmVzb2x1dGlvblVuaXQ+CiAgICAgI"+
                "CAgIDx0aWZmOkNvbXByZXNzaW9uPjU8L3RpZmY6Q29tcHJlc3Npb24+CiAgICAgICAgIDx0aWZmOlhSZXNvbHV0aW9uPjcyPC90aWZmOlhSZX"+
                "NvbHV0aW9uPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgogICAgICAgICA8dGlmZjpZUmVzb2x1dGl"+
                "vbj43MjwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAgPGV4aWY6UGl4ZWxYRGltZW5zaW9uPjE2PC9leGlmOlBpeGVsWERpbWVuc2lvbj4K"+
                "ICAgICAgICAgPGV4aWY6Q29sb3JTcGFjZT4xPC9leGlmOkNvbG9yU3BhY2U+CiAgICAgICAgIDxleGlmOlBpeGVsWURpbWVuc2lvbj4xNjwvZ"+
                "XhpZjpQaXhlbFlEaW1lbnNpb24+CiAgICAgICAgIDxkYzpzdWJqZWN0PgogICAgICAgICAgICA8cmRmOkJhZy8+CiAgICAgICAgIDwvZGM6c3"+
                "ViamVjdD4KICAgICAgICAgPHhtcDpNb2RpZnlEYXRlPjIwMTUtMDEtMjhUMTU6MDE6MzA8L3htcDpNb2RpZnlEYXRlPgogICAgICAgICA8eG1"+
                "wOkNyZWF0b3JUb29sPlBpeGVsbWF0b3IgMy4zLjE8L3htcDpDcmVhdG9yVG9vbD4KICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRm"+
                "OlJERj4KPC94OnhtcG1ldGE+CjaK2CoAAACDSURBVDgRY2AYVuAh0Df/icS3YD5ngjGA9BYkNiHmTmwKBIGCxLjiPVCdADYDQGK+QEzIG/m4N"+
                "MPEQc7DZch5oBwzTCEuWh0o8ROI0Q35BxSzxqUJXbwBKIBuwCJ0Rfj43EDJR0iGgAJOHJ8GbHLIAUow4LAZABLbD8T7gJgFxBmmAAAP/DrikG"+
                "TL6wAAAABJRU5ErkJggg==";
      }  
        _element.children.add(imgArrow);
      

      imgArrow.onClick.listen((L) {
        if (_node.isExpanded) {
          _node.expanded = false;
          _treeComponent._removeNodeChildren(_node);
          buildContent();
        } else {
          _node.expanded = true;
          _treeComponent._buildNodeChildren(_node);
          buildContent();
        }
        //TODO null nos listeners
        if(_node.listener != null)
        _node.listener.onExpandAction(_node);
      });

    }

    SpanElement spanElementName = new SpanElement()
    ..text = _node.name;
    
    spanElementName.onClick.listen((L){
      if(_node.listener != null)
      _node.listener.onClickAction(_node);
    });
    

    if(_node.properties['color']!=null){
      LabelElement colorLabel = new LabelElement()
      ..id="color"
      ..style.backgroundColor=_node.properties['color']
       ..htmlFor=checkBox.id
      ..style.margin="3px"
      ..style.fontSize="80%"
      ..style.verticalAlign="text-top"
      ..setInnerHtml("&nbsp;&nbsp;&nbsp;")
      ;
      _element.children.add(colorLabel);
    }
    _element.children.add(checkBox);
    _element.children.add(spanElementName); //TODO adicionar listener aqui!

  }

  void remove() {
    _element.remove();
    _element = null;
  }

}


class TreeNode {
  String name;
  Map properties;

  TreeNode _parent;
  List<TreeNode> _children = [];

  bool _expanded = false;
  bool _checked = false;

  TreeNode.root(this.name, [this.properties, this._expanded = true, this._checked = true]) {
    checkInit();
  }

  TreeNode.node(this._parent, this.name, [this.properties, this._expanded = false, this._checked = false]) {
    checkInit();
  }

  void checkInit() {
    if (this._checked == null) this._checked = false;
    if (this._expanded == null) this._expanded = false;
    if (this.properties == null) this.properties = {};
  }

  bool get isRoot => _parent == null;
  bool get isParent => hasChildren;
  bool get hasChildren => _children.isNotEmpty;
  bool get isExpanded => _expanded;
  bool get isChecked => _checked;

  set checked(bool checked) => _checked = checked;
  set expanded(bool expanded) => _expanded = expanded;

  List<TreeNode> get children => _children;

  TreeNode get parent => _parent;

  TreeNode getRoot() {
    TreeNode cursor = this;
    do {
      if (cursor.isRoot) return cursor;
      cursor = cursor.parent;
    } while (cursor != null);

    throw new StateError("Invalid tree structure");
  }

  TreeNode createChild(String name, [Map properties, bool expanded = false]) {
    var child = new TreeNode.node(this, name, properties, expanded);
    this._children.add(child);
    return child;
  }

  /////////

  TreeNodeListener listener;

  /////////

  Element _treeElement;
  TreeNodeComponent _component;

  /////////

  Map<String, Object> toJson() => {
    "data": properties
  };

}

abstract class TreeNodeListener {

  onCheckAction(TreeNode node);
  onExpandAction(TreeNode node);
  onClickAction(TreeNode node);

}
