//var app = new Framework7();

// Framework7 同时还提供更多自定义变量，可以在初始化的时候进行定义：
var app = new Framework7({
    // App root element
    root: '#app',
    // App Name
    name: 'My App',
    // App id
    id: 'com.myapp.test',
    // Enable swipe panel
    panel: {
        swipe: 'left',
    },
    // Add default routes
    routes: [
        {
            path: '/about/',
            url: 'about.html',
        },
    ],
    // ... other parameters
});

// View 从本质上说，是一个起到导航作用的页面
// var mainView = app.views.create('.view-main');

