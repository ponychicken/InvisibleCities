var React = require('react');
var Swipeable = require('react-swipeable');

var Cover = require('./Cover.jsx');
var Menu = require('./Menu.jsx');
var Text = require('./Text.jsx');
var GridView = require('./GridView.jsx');

var menuItems = [
  'Vorwort',
  'Animation',
  'Nachwort'
];

var fillText = 'Vergeblich, großherziger Kublai, werde ich versuchen, dir die Stadt Zaira mit ihren hohen Bastionen zu beschreiben. Ich könnte dir sagen, wie viele Stufen die treppenförmigen Straßen haben, welche Wölbung die Bögen der Arkaden, mit was für';

var projects = [

  {
    author: 'Dom Okah',
    city: 'Perinthia',
    text: fillText,
    image: 'IMG_0012.png',
    landscape: true
  },
  
  {
    author: 'Lorenz',
    city: 'Unknown',
    text: fillText,
    image: 'IMG_0013.png',
    landscape: false
  },
  {
    author: 'Wiebke Helmchen',
    city: 'Chloe',
    text: fillText,
    image: 'IMG_0011.png',
    landscape: true
  },
  {
    author: 'Ilya Barret',
    city: 'Perinthia',
    text: fillText,
    image: 'IMG_0016.png',
    landscape: false
  },
];

var appTitle = "Die Unsichtbaren Städte"

var App = React.createClass({

  render: function() {
    return (
      <div>

         <Swipeable className="fullscreenPage" onSwiped={this.handleSwipe}>
          <Cover title={appTitle} subtitle="Zeichnungen + Interaktionen"/>
        </Swipeable>
        <Swipeable className="fullscreenPage" onSwiped={this.handleSwipe}>
            <Menu list={menuItems} title={appTitle}/>
            <GridView projects={projects} ref="gridView"/>
        </Swipeable>
      </div>
    );
  },
  handleSwipe: function (e, x, y, flick) {
    console.log(e, x, y, flick);
    if (flick && y > 0 && Math.abs(y) > Math.abs(x)) {
      document.body.className='page1';
      e.preventDefault();
      e.stopPropagation();
    }
    if (flick && y < 0 && Math.abs(y) > Math.abs(x)) {
      console.log(this.refs.gridView.getDOMNode().scrollTop)
      document.body.className='page0';
      e.preventDefault();
      e.stopPropagation();
    }
  }
})

React.render(
  <App/>,
  document.body
)
