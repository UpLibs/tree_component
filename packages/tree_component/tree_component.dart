library tree_component;

import 'dart:html';

class TreeComponent {

  List<TreeNode> _roots;

  TreeComponent(TreeNode roots) {
    _roots = [roots] ;
  }
  
  TreeComponent.multipleRoots(this._roots);

  TreeNode getNodeByID(String id) {
    for (var root in roots) {
      var found = root.getNodeByID(id) ;
      if (found != null) return found ;
    }
    return null ;
  }
  
  Element _parentElement;
  int _margin ;

  int get margin => _margin ;
  set margin(int size) => _margin = size != null ? ( size >= 0 ? size : 0 ) : DEFAULT_MARGIN ; 

  static const int DEFAULT_MARGIN = 16 ;
  
  List<TreeNode> get roots => new List.from( _roots ) ;
  int get rootsSize => _roots.length ;
  bool get hasMultipleRoots => roots.length > 1 ;
  
  void buildAt(Element parentElement,[int margin = DEFAULT_MARGIN]) {
    if (this._parentElement != null) remove();

    this._parentElement = parentElement;
    this._margin = margin != null ? margin : DEFAULT_MARGIN ;

    _buildTree(parentElement);
  }
  
  void rebuild() {
    _buildTree(this._parentElement);
  }
  
  UListElement _elemUlRoot ;
  
  void _buildTree(Element parentElement) {
    
    if (_elemUlRoot != null) {
      _elemUlRoot.remove() ;
    }
    
    _elemUlRoot = new UListElement();
    _elemUlRoot.style.listStyleType = 'none';
    _elemUlRoot.style.paddingLeft = "0px";

    parentElement.children.add(_elemUlRoot);
   
    for (var root in _roots) {
      _buildNode(_elemUlRoot, root) ;
    }
    
  }
  
  void _buildNode(Element parentElement, TreeNode node) {
    
    if ( node.isHidden ) {
      return ;
    }
    
    if ( node._component != null ) {
      node._component.remove() ;
    }
    
    UListElement elem = new UListElement();
    elem.style.listStyleType = 'none';
    
    int margin = 0 ;
    
    if (!node.hasChildren) margin += 16 ;
    
    if (node.properties['color'] == null) margin += 10+(3*2) ;
    
    if (margin > 0) {
      elem.style.marginLeft = "${margin}px";
    }
    
    elem.style.paddingLeft = "${_margin}px";

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
    
    if (_elemUlRoot != null) {
      _elemUlRoot.remove() ;
      _elemUlRoot = null ;
    }

    for (var root in _roots) {
      _removeNode(root);  
    }
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
  
  static String _IMG_ARROW_RIGHT =  "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABmJLR0QA/wD/AP+gvaeTAAAAg0lEQVQ4jcXPrQ0CQRRF4Y8fh0LRwVIENVALLdAEDdAFBrsSj1sawIJhMWxCXibhZRB7kytGnDP3MXZm4X1FgxaPGmH/6R27wgdpwdALNv8IerxwxKpWEM+a1wqGnr+BaWZWyKR2wQ3bX/YS+MQei8y8CJ+wzoBR0GXmltLhgGUNPE7e4DU8I8utB5cAAAAASUVORK5CYII=" ;
  static String _IMG_ARROW_DOWN = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAAXNSR0IArs4c6QAAAAlwSFl"+
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
                "TL6wAAAABJRU5ErkJggg==" ;
  
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
  
  CheckboxInputElement checkBox;

  void buildContent() {

    for (var child in new List.from(_element.children)) {
      child.remove();
    }

    checkBox = new CheckboxInputElement();
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
      ..src = ( _node.isExpanded ? _IMG_ARROW_DOWN : _IMG_ARROW_RIGHT) ;
      
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
    else {
      
    }

    SpanElement spanElementName = new SpanElement()
    ..text = _node.label;
    
    spanElementName.onClick.listen((L){
      if(_node.listener != null)
      _node.listener.onClickAction(_node);
    });

    if(_node.properties['color']!=null){
      DivElement colorLabel = new DivElement()
      ..id="color"
      ..style.backgroundColor=_node.properties['color']
      //..style.htmlFor=checkBox.id
      ..style.margin="3px"
      ..style.width ="10px"
      ..style.height ="10px"
      ..style.fontSize="30%"
      ..style.display="inline-block"
      ..style.verticalAlign="7px"
      ..style.borderRadius= '5px'
      ..setInnerHtml("&nbsp;")
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
  String label;
  Map properties;
  String id;

  TreeNode _parent;
  List<TreeNode> _children = [];

  bool _hidden = false ;
  
  bool _expanded ;
  bool _checked ;

  TreeNode.root(this.label, this.id, [this.properties,this._checked = true, this._expanded = true ]) {
    checkInit();
  }

  TreeNode.node(this._parent, this.label, this.id, [this.properties, this._checked = false, this._expanded = false]) {
    checkInit();
    _parent._children.add(this);
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
  
  bool get isHidden => _hidden ;
  
  TreeNode getNodeByID(String id) {
    if ( this.id == id ) return this ;
    
    for (var node in _children) {
      var found = node.getNodeByID(id) ;
      if (found != null) return found ;
    }
    
    return null ;
  }
  
  List<TreeNode> getAllSubNodes( [bool addThisNode = true] ){
    List<TreeNode> all = [] ;
    
    if (addThisNode) all.add(this) ;
    
    _addAllSubNodes(all) ;
    
    return all ;
  }
  
  void _addAllSubNodes(List<TreeNode> all){
    for (var node in _children) {
      all.add(node) ;
      node._addAllSubNodes(all) ;
    }
  }
  
  set checked(bool checked) {
    _checked = checked;
        
    if(_component !=null && _component.checkBox != null) {
      this._component.checkBox.checked = _checked;
    }  
  }
  
  set expanded(bool expanded) => _expanded = expanded;
  set hidden(bool hidden) => _hidden = hidden;
  
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

  TreeNode createChild(String name, String id, [Map properties, bool expanded = false]) {
    var child = new TreeNode.node(this, name, id, properties, expanded);
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
