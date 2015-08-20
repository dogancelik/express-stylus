# express-stylus
Extended version of Stylus middleware with support for `use` and `import` inside options.

## Install
```
npm install express-stylus
```

## Options

[These options are taken from the official website and supported](http://learnboost.github.io/stylus/docs/middleware.html)

<!--* `serve`     Serve the stylus files from `dest` [true]-->
* `force`     Always re-compile
* `src`       Source directory used to find .styl files
* `dest`      Destination directory used to output .css files when undefined defaults to `src`.
<!--* `compile`   Custom compile function, accepting the arguments `(str, path)`.-->
* `compress`  Whether the output .css files should be compressed
* `firebug`   Emits debug infos in the generated css that can be used by the FireStylus Firebug plugin
* `linenos`   Emits comments in the generated css indicating the corresponding stylus line
* `sourcemap` Generates a sourcemap in sourcemaps v3 format

**Extra options supported by this middleware:**

* `use`: An array of initialized functions
* `import`: An array of Stylus module names

## Example

```js
var express = require('express');
var stylus = require('express-stylus');
var nib = require('nib');
var join = require('path').join;
var publicDir = join(__dirname, '/public');

var app = express();
app.use(stylus({
  src: publicDir,
  use: [nib()],
  import: ['nib']
}));
app.use(express.static(publicDir));
app.listen(80);
```

Now create a `test.styl` inside `public` folder and visit `localhost/test.css` in browser.
