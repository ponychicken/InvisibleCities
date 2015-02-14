var React = require('react/addons');
var Swipeable = require('react-swipeable');

var MenuIcon = React.createClass({
  render: function() {
    return (
      <div className='menuIcon'>
        <div className='icon'></div>
        <span className='text'>Menu</span>
      </div>
    );
  }
});

var MenuList = React.createClass({
  render: function() {
    var listNodes = this.props.list.map(function(item) {
      return (
        <li>{item}</li>
      );
    })
    
    return (
      <ul>
        {listNodes}
      </ul>
    );
  }
});

var Menu = React.createClass({
  getInitialState: function() {
    return {
      activeTitle: this.props.list[0],
      expanded: false
    };
  },
  render: function() {
    var cx = React.addons.classSet;
    var classes = cx({
      'menu': true,
      'expanded': this.state.expanded,
      'collapsed': !this.state.expanded
    });
    
    return (
      <Swipeable onSwiped={this.handleSwipe}>
        <div className={classes} onClick={this.toggle}>
          <MenuIcon />
          <h1 className='appTitle'>{this.props.title}</h1>
          <div className='currentTitle'>{this.state.activeTitle}</div>
          <MenuList list={this.props.list}/>
        </div>
      </Swipeable>
    );
  },
  handleSwipe: function (e, x, y, flick) {
    console.log(99, e, x, y, flick);
    if (flick && Math.abs(y) < Math.abs(x)) {
      this.setState({
        expanded: (x < 0)
      });
      e.stopPropagation();
    }
  },
  toggle: function() {
    this.setState({
      expanded: !this.state.expanded
    });
  }
});

module.exports = Menu;
