/*!
 * jQuery JavaScript Library v1.3.2
 * http://jquery.com/
 *
 * Copyright (c) 2009 John Resig
 * Dual licensed under the MIT and GPL licenses.
 * http://docs.jquery.com/License
 *
 * Date: 2009-02-19 17:34:21 -0500 (Thu, 19 Feb 2009)
 * Revision: 6246
 */
(function(){

var
	window = this,
	undefined,
	_jQuery = window.jQuery,
	_$ = window.$,

	jQuery = window.jQuery = window.$ = function( selector, context ) {
		return new jQuery.fn.init( selector, context );
	},

	quickExpr = /^[^<]*(<(.|\s)+>)[^>]*$|^#([\w-]+)$/,
	isSimple = /^.[^:#\[\.,]*$/;

jQuery.fn = jQuery.prototype = {
	init: function( selector, context ) {
		selector = selector || document;

		if ( selector.nodeType ) {
			this[0] = selector;
			this.length = 1;
			this.context = selector;
			return this;
		}
		if ( typeof selector === "string" ) {
			var match = quickExpr.exec( selector );

			if ( match && (match[1] || !context) ) {

				if ( match[1] )
					selector = jQuery.clean( [ match[1] ], context );

				else {
					var elem = document.getElementById( match[3] );

					if ( elem && elem.id != match[3] )
						return jQuery().find( selector );

					var ret = jQuery( elem || [] );
					ret.context = document;
					ret.selector = selector;
					return ret;
				}

			} else
				return jQuery( context ).find( selector );

		} else if ( jQuery.isFunction( selector ) )
			return jQuery( document ).ready( selector );

		if ( selector.selector && selector.context ) {
			this.selector = selector.selector;
			this.context = selector.context;
		}

		return this.setArray(jQuery.isArray( selector ) ?
			selector :
			jQuery.makeArray(selector));
	},

	selector: "",

	jquery: "1.3.2",

	size: function() {
		return this.length;
	},

	get: function( num ) {
		return num === undefined ?

			Array.prototype.slice.call( this ) :

			this[ num ];
	},

	pushStack: function( elems, name, selector ) {
		var ret = jQuery( elems );

		ret.prevObject = this;

		ret.context = this.context;

		if ( name === "find" )
			ret.selector = this.selector + (this.selector ? " " : "") + selector;
		else if ( name )
			ret.selector = this.selector + "." + name + "(" + selector + ")";

		return ret;
	},

	setArray: function( elems ) {
		this.length = 0;
		Array.prototype.push.apply( this, elems );

		return this;
	},

	each: function( callback, args ) {
		return jQuery.each( this, callback, args );
	},

	index: function( elem ) {
		return jQuery.inArray(
			elem && elem.jquery ? elem[0] : elem
		, this );
	},

	attr: function( name, value, type ) {
		var options = name;

		if ( typeof name === "string" )
			if ( value === undefined )
				return this[0] && jQuery[ type || "attr" ]( this[0], name );

			else {
				options = {};
				options[ name ] = value;
			}

		return this.each(function(i){
			for ( name in options )
				jQuery.attr(
					type ?
						this.style :
						this,
					name, jQuery.prop( this, options[ name ], type, i, name )
				);
		});
	},

	css: function( key, value ) {
		if ( (key == 'width' || key == 'height') && parseFloat(value) < 0 )
			value = undefined;
		return this.attr( key, value, "curCSS" );
	},

	text: function( text ) {
		if ( typeof text !== "object" && text != null )
			return this.empty().append( (this[0] && this[0].ownerDocument || document).createTextNode( text ) );

		var ret = "";

		jQuery.each( text || this, function(){
			jQuery.each( this.childNodes, function(){
				if ( this.nodeType != 8 )
					ret += this.nodeType != 1 ?
						this.nodeValue :
						jQuery.fn.text( [ this ] );
			});
		});

		return ret;
	},

	wrapAll: function( html ) {
		if ( this[0] ) {
			var wrap = jQuery( html, this[0].ownerDocument ).clone();

			if ( this[0].parentNode )
				wrap.insertBefore( this[0] );

			wrap.map(function(){
				var elem = this;

				while ( elem.firstChild )
					elem = elem.firstChild;

				return elem;
			}).append(this);
		}

		return this;
	},

	wrapInner: function( html ) {
		return this.each(function(){
			jQuery( this ).contents().wrapAll( html );
		});
	},

	wrap: function( html ) {
		return this.each(function(){
			jQuery( this ).wrapAll( html );
		});
	},

	append: function() {
		return this.domManip(arguments, true, function(elem){
			if (this.nodeType == 1)
				this.appendChild( elem );
		});
	},

	prepend: function() {
		return this.domManip(arguments, true, function(elem){
			if (this.nodeType == 1)
				this.insertBefore( elem, this.firstChild );
		});
	},

	before: function() {
		return this.domManip(arguments, false, function(elem){
			this.parentNode.insertBefore( elem, this );
		});
	},

	after: function() {
		return this.domManip(arguments, false, function(elem){
			this.parentNode.insertBefore( elem, this.nextSibling );
		});
	},

	end: function() {
		return this.prevObject || jQuery( [] );
	},

	push: [].push,
	sort: [].sort,
	splice: [].splice,

	find: function( selector ) {
		if ( this.length === 1 ) {
			var ret = this.pushStack( [], "find", selector );
			ret.length = 0;
			jQuery.find( selector, this[0], ret );
			return ret;
		} else {
			return this.pushStack( jQuery.unique(jQuery.map(this, function(elem){
				return jQuery.find( selector, elem );
			})), "find", selector );
		}
	},

	clone: function( events ) {
		var ret = this.map(function(){
			if ( !jQuery.support.noCloneEvent && !jQuery.isXMLDoc(this) ) {
				var html = this.outerHTML;
				if ( !html ) {
					var div = this.ownerDocument.createElement("div");
					div.appendChild( this.cloneNode(true) );
					html = div.innerHTML;
				}

				return jQuery.clean([html.replace(/ jQuery\d+="(?:\d+|null)"/g, "").replace(/^\s*/, "")])[0];
			} else
				return this.cloneNode(true);
		});

		if ( events === true ) {
			var orig = this.find("*").andSelf(), i = 0;

			ret.find("*").andSelf().each(function(){
				if ( this.nodeName !== orig[i].nodeName )
					return;

				var events = jQuery.data( orig[i], "events" );

				for ( var type in events ) {
					for ( var handler in events[ type ] ) {
						jQuery.event.add( this, type, events[ type ][ handler ], events[ type ][ handler ].data );
					}
				}

				i++;
			});
		}

		return ret;
	},

	filter: function( selector ) {
		return this.pushStack(
			jQuery.isFunction( selector ) &&
			jQuery.grep(this, function(elem, i){
				return selector.call( elem, i );
			}) ||

			jQuery.multiFilter( selector, jQuery.grep(this, function(elem){
				return elem.nodeType === 1;
			}) ), "filter", selector );
	},

	closest: function( selector ) {
		var pos = jQuery.expr.match.POS.test( selector ) ? jQuery(selector) : null,
			closer = 0;

		return this.map(function(){
			var cur = this;
			while ( cur && cur.ownerDocument ) {
				if ( pos ? pos.index(cur) > -1 : jQuery(cur).is(selector) ) {
					jQuery.data(cur, "closest", closer);
					return cur;
				}
				cur = cur.parentNode;
				closer++;
			}
		});
	},

	not: function( selector ) {
		if ( typeof selector === "string" )
			if ( isSimple.test( selector ) )
				return this.pushStack( jQuery.multiFilter( selector, this, true ), "not", selector );
			else
				selector = jQuery.multiFilter( selector, this );

		var isArrayLike = selector.length && selector[selector.length - 1] !== undefined && !selector.nodeType;
		return this.filter(function() {
			return isArrayLike ? jQuery.inArray( this, selector ) < 0 : this != selector;
		});
	},

	add: function( selector ) {
		return this.pushStack( jQuery.unique( jQuery.merge(
			this.get(),
			typeof selector === "string" ?
				jQuery( selector ) :
				jQuery.makeArray( selector )
		)));
	},

	is: function( selector ) {
		return !!selector && jQuery.multiFilter( selector, this ).length > 0;
	},

	hasClass: function( selector ) {
		return !!selector && this.is( "." + selector );
	},

	val: function( value ) {
		if ( value === undefined ) {
			var elem = this[0];

			if ( elem ) {
				if( jQuery.nodeName( elem, 'option' ) )
					return (elem.attributes.value || {}).specified ? elem.value : elem.text;

				if ( jQuery.nodeName( elem, "select" ) ) {
					var index = elem.selectedIndex,
						values = [],
						options = elem.options,
						one = elem.type == "select-one";

					if ( index < 0 )
						return null;

					for ( var i = one ? index : 0, max = one ? index + 1 : options.length; i < max; i++ ) {
						var option = options[ i ];

						if ( option.selected ) {
							value = jQuery(option).val();

							if ( one )
								return value;

							values.push( value );
						}
					}

					return values;
				}

				return (elem.value || "").replace(/\r/g, "");

			}

			return undefined;
		}

		if ( typeof value === "number" )
			value += '';

		return this.each(function(){
			if ( this.nodeType != 1 )
				return;

			if ( jQuery.isArray(value) && /radio|checkbox/.test( this.type ) )
				this.checked = (jQuery.inArray(this.value, value) >= 0 ||
					jQuery.inArray(this.name, value) >= 0);

			else if ( jQuery.nodeName( this, "select" ) ) {
				var values = jQuery.makeArray(value);

				jQuery( "option", this ).each(function(){
					this.selected = (jQuery.inArray( this.value, values ) >= 0 ||
						jQuery.inArray( this.text, values ) >= 0);
				});

				if ( !values.length )
					this.selectedIndex = -1;

			} else
				this.value = value;
		});
	},

	html: function( value ) {
		return value === undefined ?
			(this[0] ?
				this[0].innerHTML.replace(/ jQuery\d+="(?:\d+|null)"/g, "") :
				null) :
			this.empty().append( value );
	},

	replaceWith: function( value ) {
		return this.after( value ).remove();
	},

	eq: function( i ) {
		return this.slice( i, +i + 1 );
	},

	slice: function() {
		return this.pushStack( Array.prototype.slice.apply( this, arguments ),
			"slice", Array.prototype.slice.call(arguments).join(",") );
	},

	map: function( callback ) {
		return this.pushStack( jQuery.map(this, function(elem, i){
			return callback.call( elem, i, elem );
		}));
	},

	andSelf: function() {
		return this.add( this.prevObject );
	},

	domManip: function( args, table, callback ) {
		if ( this[0] ) {
			var fragment = (this[0].ownerDocument || this[0]).createDocumentFragment(),
				scripts = jQuery.clean( args, (this[0].ownerDocument || this[0]), fragment ),
				first = fragment.firstChild;

			if ( first )
				for ( var i = 0, l = this.length; i < l; i++ )
					callback.call( root(this[i], first), this.length > 1 || i > 0 ?
							fragment.cloneNode(true) : fragment );

			if ( scripts )
				jQuery.each( scripts, evalScript );
		}

		return this;

		function root( elem, cur ) {
			return table && jQuery.nodeName(elem, "table") && jQuery.nodeName(cur, "tr") ?
				(elem.getElementsByTagName("tbody")[0] ||
				elem.appendChild(elem.ownerDocument.createElement("tbody"))) :
				elem;
		}
	}
};

jQuery.fn.init.prototype = jQuery.fn;

function evalScript( i, elem ) {
	if ( elem.src )
		jQuery.ajax({
			url: elem.src,
			async: false,
			dataType: "script"
		});

	else
		jQuery.globalEval( elem.text || elem.textContent || elem.innerHTML || "" );

	if ( elem.parentNode )
		elem.parentNode.removeChild( elem );
}

function now(){
	return +new Date;
}

jQuery.extend = jQuery.fn.extend = function() {
	var target = arguments[0] || {}, i = 1, length = arguments.length, deep = false, options;

	if ( typeof target === "boolean" ) {
		deep = target;
		target = arguments[1] || {};
		i = 2;
	}

	if ( typeof target !== "object" && !jQuery.isFunction(target) )
		target = {};

	if ( length == i ) {
		target = this;
		--i;
	}

	for ( ; i < length; i++ )
		if ( (options = arguments[ i ]) != null )
			for ( var name in options ) {
				var src = target[ name ], copy = options[ name ];

				if ( target === copy )
					continue;

				if ( deep && copy && typeof copy === "object" && !copy.nodeType )
					target[ name ] = jQuery.extend( deep,
						src || ( copy.length != null ? [ ] : { } )
					, copy );

				else if ( copy !== undefined )
					target[ name ] = copy;

			}

	return target;
};

var	exclude = /z-?index|font-?weight|opacity|zoom|line-?height/i,
	defaultView = document.defaultView || {},
	toString = Object.prototype.toString;

jQuery.extend({
	noConflict: function( deep ) {
		window.$ = _$;

		if ( deep )
			window.jQuery = _jQuery;

		return jQuery;
	},

	isFunction: function( obj ) {
		return toString.call(obj) === "[object Function]";
	},

	isArray: function( obj ) {
		return toString.call(obj) === "[object Array]";
	},

	isXMLDoc: function( elem ) {
		return elem.nodeType === 9 && elem.documentElement.nodeName !== "HTML" ||
			!!elem.ownerDocument && jQuery.isXMLDoc( elem.ownerDocument );
	},

	globalEval: function( data ) {
		if ( data && /\S/.test(data) ) {
			var head = document.getElementsByTagName("head")[0] || document.documentElement,
				script = document.createElement("script");

			script.type = "text/javascript";
			if ( jQuery.support.scriptEval )
				script.appendChild( document.createTextNode( data ) );
			else
				script.text = data;

			head.insertBefore( script, head.firstChild );
			head.removeChild( script );
		}
	},

	nodeName: function( elem, name ) {
		return elem.nodeName && elem.nodeName.toUpperCase() == name.toUpperCase();
	},

	each: function( object, callback, args ) {
		var name, i = 0, length = object.length;

		if ( args ) {
			if ( length === undefined ) {
				for ( name in object )
					if ( callback.apply( object[ name ], args ) === false )
						break;
			} else
				for ( ; i < length; )
					if ( callback.apply( object[ i++ ], args ) === false )
						break;

		} else {
			if ( length === undefined ) {
				for ( name in object )
					if ( callback.call( object[ name ], name, object[ name ] ) === false )
						break;
			} else
				for ( var value = object[0];
					i < length && callback.call( value, i, value ) !== false; value = object[++i] ){}
		}

		return object;
	},

	prop: function( elem, value, type, i, name ) {
		if ( jQuery.isFunction( value ) )
			value = value.call( elem, i );

		return typeof value === "number" && type == "curCSS" && !exclude.test( name ) ?
			value + "px" :
			value;
	},

	className: {
		add: function( elem, classNames ) {
			jQuery.each((classNames || "").split(/\s+/), function(i, className){
				if ( elem.nodeType == 1 && !jQuery.className.has( elem.className, className ) )
					elem.className += (elem.className ? " " : "") + className;
			});
		},

		remove: function( elem, classNames ) {
			if (elem.nodeType == 1)
				elem.className = classNames !== undefined ?
					jQuery.grep(elem.className.split(/\s+/), function(className){
						return !jQuery.className.has( classNames, className );
					}).join(" ") :
					"";
		},

		has: function( elem, className ) {
			return elem && jQuery.inArray( className, (elem.className || elem).toString().split(/\s+/) ) > -1;
		}
	},

	swap: function( elem, options, callback ) {
		var old = {};
		for ( var name in options ) {
			old[ name ] = elem.style[ name ];
			elem.style[ name ] = options[ name ];
		}

		callback.call( elem );

		for ( var name in options )
			elem.style[ name ] = old[ name ];
	},

	css: function( elem, name, force, extra ) {
		if ( name == "width" || name == "height" ) {
			var val, props = { position: "absolute", visibility: "hidden", display:"block" }, which = name == "width" ? [ "Left", "Right" ] : [ "Top", "Bottom" ];

			function getWH() {
				val = name == "width" ? elem.offsetWidth : elem.offsetHeight;

				if ( extra === "border" )
					return;

				jQuery.each( which, function() {
					if ( !extra )
						val -= parseFloat(jQuery.curCSS( elem, "padding" + this, true)) || 0;
					if ( extra === "margin" )
						val += parseFloat(jQuery.curCSS( elem, "margin" + this, true)) || 0;
					else
						val -= parseFloat(jQuery.curCSS( elem, "border" + this + "Width", true)) || 0;
				});
			}

			if ( elem.offsetWidth !== 0 )
				getWH();
			else
				jQuery.swap( elem, props, getWH );

			return Math.max(0, Math.round(val));
		}

		return jQuery.curCSS( elem, name, force );
	},

	curCSS: function( elem, name, force ) {
		var ret, style = elem.style;

		if ( name == "opacity" && !jQuery.support.opacity ) {
			ret = jQuery.attr( style, "opacity" );

			return ret == "" ?
				"1" :
				ret;
		}

		if ( name.match( /float/i ) )
			name = styleFloat;

		if ( !force && style && style[ name ] )
			ret = style[ name ];

		else if ( defaultView.getComputedStyle ) {

			if ( name.match( /float/i ) )
				name = "float";

			name = name.replace( /([A-Z])/g, "-$1" ).toLowerCase();

			var computedStyle = defaultView.getComputedStyle( elem, null );

			if ( computedStyle )
				ret = computedStyle.getPropertyValue( name );

			if ( name == "opacity" && ret == "" )
				ret = "1";

		} else if ( elem.currentStyle ) {
			var camelCase = name.replace(/\-(\w)/g, function(all, letter){
				return letter.toUpperCase();
			});

			ret = elem.currentStyle[ name ] || elem.currentStyle[ camelCase ];


			if ( !/^\d+(px)?$/i.test( ret ) && /^\d/.test( ret ) ) {
				var left = style.left, rsLeft = elem.runtimeStyle.left;

				elem.runtimeStyle.left = elem.currentStyle.left;
				style.left = ret || 0;
				ret = style.pixelLeft + "px";

				style.left = left;
				elem.runtimeStyle.left = rsLeft;
			}
		}

		return ret;
	},

	clean: function( elems, context, fragment ) {
		context = context || document;

		if ( typeof context.createElement === "undefined" )
			context = context.ownerDocument || context[0] && context[0].ownerDocument || document;

		if ( !fragment && elems.length === 1 && typeof elems[0] === "string" ) {
			var match = /^<(\w+)\s*\/?>$/.exec(elems[0]);
			if ( match )
				return [ context.createElement( match[1] ) ];
		}

		var ret = [], scripts = [], div = context.createElement("div");

		jQuery.each(elems, function(i, elem){
			if ( typeof elem === "number" )
				elem += '';

			if ( !elem )
				return;

			if ( typeof elem === "string" ) {
				elem = elem.replace(/(<(\w+)[^>]*?)\/>/g, function(all, front, tag){
					return tag.match(/^(abbr|br|col|img|input|link|meta|param|hr|area|embed)$/i) ?
						all :
						front + "></" + tag + ">";
				});

				var tags = elem.replace(/^\s+/, "").substring(0, 10).toLowerCase();

				var wrap =
					!tags.indexOf("<opt") &&
					[ 1, "<select multiple='multiple'>", "</select>" ] ||

					!tags.indexOf("<leg") &&
					[ 1, "<fieldset>", "</fieldset>" ] ||

					tags.match(/^<(thead|tbody|tfoot|colg|cap)/) &&
					[ 1, "<table>", "</table>" ] ||

					!tags.indexOf("<tr") &&
					[ 2, "<table><tbody>", "</tbody></table>" ] ||

					(!tags.indexOf("<td") || !tags.indexOf("<th")) &&
					[ 3, "<table><tbody><tr>", "</tr></tbody></table>" ] ||

					!tags.indexOf("<col") &&
					[ 2, "<table><tbody></tbody><colgroup>", "</colgroup></table>" ] ||

					!jQuery.support.htmlSerialize &&
					[ 1, "div<div>", "</div>" ] ||

					[ 0, "", "" ];

				div.innerHTML = wrap[1] + elem + wrap[2];

				while ( wrap[0]-- )
					div = div.lastChild;

				if ( !jQuery.support.tbody ) {

					var hasBody = /<tbody/i.test(elem),
						tbody = !tags.indexOf("<table") && !hasBody ?
							div.firstChild && div.firstChild.childNodes :

						wrap[1] == "<table>" && !hasBody ?
							div.childNodes :
							[];

					for ( var j = tbody.length - 1; j >= 0 ; --j )
						if ( jQuery.nodeName( tbody[ j ], "tbody" ) && !tbody[ j ].childNodes.length )
							tbody[ j ].parentNode.removeChild( tbody[ j ] );

					}

				if ( !jQuery.support.leadingWhitespace && /^\s/.test( elem ) )
					div.insertBefore( context.createTextNode( elem.match(/^\s*/)[0] ), div.firstChild );

				elem = jQuery.makeArray( div.childNodes );
			}

			if ( elem.nodeType )
				ret.push( elem );
			else
				ret = jQuery.merge( ret, elem );

		});

		if ( fragment ) {
			for ( var i = 0; ret[i]; i++ ) {
				if ( jQuery.nodeName( ret[i], "script" ) && (!ret[i].type || ret[i].type.toLowerCase() === "text/javascript") ) {
					scripts.push( ret[i].parentNode ? ret[i].parentNode.removeChild( ret[i] ) : ret[i] );
				} else {
					if ( ret[i].nodeType === 1 )
						ret.splice.apply( ret, [i + 1, 0].concat(jQuery.makeArray(ret[i].getElementsByTagName("script"))) );
					fragment.appendChild( ret[i] );
				}
			}

			return scripts;
		}

		return ret;
	},

	attr: function( elem, name, value ) {
		if (!elem || elem.nodeType == 3 || elem.nodeType == 8)
			return undefined;

		var notxml = !jQuery.isXMLDoc( elem ),
			set = value !== undefined;

		name = notxml && jQuery.props[ name ] || name;

		if ( elem.tagName ) {

			var special = /href|src|style/.test( name );

			if ( name == "selected" && elem.parentNode )
				elem.parentNode.selectedIndex;

			if ( name in elem && notxml && !special ) {
				if ( set ){
					if ( name == "type" && jQuery.nodeName( elem, "input" ) && elem.parentNode )
						throw "type property can't be changed";

					elem[ name ] = value;
				}

				if( jQuery.nodeName( elem, "form" ) && elem.getAttributeNode(name) )
					return elem.getAttributeNode( name ).nodeValue;

				if ( name == "tabIndex" ) {
					var attributeNode = elem.getAttributeNode( "tabIndex" );
					return attributeNode && attributeNode.specified
						? attributeNode.value
						: elem.nodeName.match(/(button|input|object|select|textarea)/i)
							? 0
							: elem.nodeName.match(/^(a|area)$/i) && elem.href
								? 0
								: undefined;
				}

				return elem[ name ];
			}

			if ( !jQuery.support.style && notxml &&  name == "style" )
				return jQuery.attr( elem.style, "cssText", value );

			if ( set )
				elem.setAttribute( name, "" + value );

			var attr = !jQuery.support.hrefNormalized && notxml && special
					? elem.getAttribute( name, 2 )
					: elem.getAttribute( name );

			return attr === null ? undefined : attr;
		}


		if ( !jQuery.support.opacity && name == "opacity" ) {
			if ( set ) {
				elem.zoom = 1;

				elem.filter = (elem.filter || "").replace( /alpha\([^)]*\)/, "" ) +
					(parseInt( value ) + '' == "NaN" ? "" : "alpha(opacity=" + value * 100 + ")");
			}

			return elem.filter && elem.filter.indexOf("opacity=") >= 0 ?
				(parseFloat( elem.filter.match(/opacity=([^)]*)/)[1] ) / 100) + '':
				"";
		}

		name = name.replace(/-([a-z])/ig, function(all, letter){
			return letter.toUpperCase();
		});

		if ( set )
			elem[ name ] = value;

		return elem[ name ];
	},

	trim: function( text ) {
		return (text || "").replace( /^\s+|\s+$/g, "" );
	},

	makeArray: function( array ) {
		var ret = [];

		if( array != null ){
			var i = array.length;
			if( i == null || typeof array === "string" || jQuery.isFunction(array) || array.setInterval )
				ret[0] = array;
			else
				while( i )
					ret[--i] = array[i];
		}

		return ret;
	},

	inArray: function( elem, array ) {
		for ( var i = 0, length = array.length; i < length; i++ )
			if ( array[ i ] === elem )
				return i;

		return -1;
	},

	merge: function( first, second ) {
		var i = 0, elem, pos = first.length;
		if ( !jQuery.support.getAll ) {
			while ( (elem = second[ i++ ]) != null )
				if ( elem.nodeType != 8 )
					first[ pos++ ] = elem;

		} else
			while ( (elem = second[ i++ ]) != null )
				first[ pos++ ] = elem;

		return first;
	},

	unique: function( array ) {
		var ret = [], done = {};

		try {

			for ( var i = 0, length = array.length; i < length; i++ ) {
				var id = jQuery.data( array[ i ] );

				if ( !done[ id ] ) {
					done[ id ] = true;
					ret.push( array[ i ] );
				}
			}

		} catch( e ) {
			ret = array;
		}

		return ret;
	},

	grep: function( elems, callback, inv ) {
		var ret = [];

		for ( var i = 0, length = elems.length; i < length; i++ )
			if ( !inv != !callback( elems[ i ], i ) )
				ret.push( elems[ i ] );

		return ret;
	},

	map: function( elems, callback ) {
		var ret = [];

		for ( var i = 0, length = elems.length; i < length; i++ ) {
			var value = callback( elems[ i ], i );

			if ( value != null )
				ret[ ret.length ] = value;
		}

		return ret.concat.apply( [], ret );
	}
});


var userAgent = navigator.userAgent.toLowerCase();

jQuery.browser = {
	version: (userAgent.match( /.+(?:rv|it|ra|ie)[\/: ]([\d.]+)/ ) || [0,'0'])[1],
	safari: /webkit/.test( userAgent ),
	opera: /opera/.test( userAgent ),
	msie: /msie/.test( userAgent ) && !/opera/.test( userAgent ),
	mozilla: /mozilla/.test( userAgent ) && !/(compatible|webkit)/.test( userAgent )
};

jQuery.each({
	parent: function(elem){return elem.parentNode;},
	parents: function(elem){return jQuery.dir(elem,"parentNode");},
	next: function(elem){return jQuery.nth(elem,2,"nextSibling");},
	prev: function(elem){return jQuery.nth(elem,2,"previousSibling");},
	nextAll: function(elem){return jQuery.dir(elem,"nextSibling");},
	prevAll: function(elem){return jQuery.dir(elem,"previousSibling");},
	siblings: function(elem){return jQuery.sibling(elem.parentNode.firstChild,elem);},
	children: function(elem){return jQuery.sibling(elem.firstChild);},
	contents: function(elem){return jQuery.nodeName(elem,"iframe")?elem.contentDocument||elem.contentWindow.document:jQuery.makeArray(elem.childNodes);}
}, function(name, fn){
	jQuery.fn[ name ] = function( selector ) {
		var ret = jQuery.map( this, fn );

		if ( selector && typeof selector == "string" )
			ret = jQuery.multiFilter( selector, ret );

		return this.pushStack( jQuery.unique( ret ), name, selector );
	};
});

jQuery.each({
	appendTo: "append",
	prependTo: "prepend",
	insertBefore: "before",
	insertAfter: "after",
	replaceAll: "replaceWith"
}, function(name, original){
	jQuery.fn[ name ] = function( selector ) {
		var ret = [], insert = jQuery( selector );

		for ( var i = 0, l = insert.length; i < l; i++ ) {
			var elems = (i > 0 ? this.clone(true) : this).get();
			jQuery.fn[ original ].apply( jQuery(insert[i]), elems );
			ret = ret.concat( elems );
		}

		return this.pushStack( ret, name, selector );
	};
});

jQuery.each({
	removeAttr: function( name ) {
		jQuery.attr( this, name, "" );
		if (this.nodeType == 1)
			this.removeAttribute( name );
	},

	addClass: function( classNames ) {
		jQuery.className.add( this, classNames );
	},

	removeClass: function( classNames ) {
		jQuery.className.remove( this, classNames );
	},

	toggleClass: function( classNames, state ) {
		if( typeof state !== "boolean" )
			state = !jQuery.className.has( this, classNames );
		jQuery.className[ state ? "add" : "remove" ]( this, classNames );
	},

	remove: function( selector ) {
		if ( !selector || jQuery.filter( selector, [ this ] ).length ) {
			jQuery( "*", this ).add([this]).each(function(){
				jQuery.event.remove(this);
				jQuery.removeData(this);
			});
			if (this.parentNode)
				this.parentNode.removeChild( this );
		}
	},

	empty: function() {
		jQuery(this).children().remove();

		while ( this.firstChild )
			this.removeChild( this.firstChild );
	}
}, function(name, fn){
	jQuery.fn[ name ] = function(){
		return this.each( fn, arguments );
	};
});

function num(elem, prop) {
	return elem[0] && parseInt( jQuery.curCSS(elem[0], prop, true), 10 ) || 0;
}
var expando = "jQuery" + now(), uuid = 0, windowData = {};

jQuery.extend({
	cache: {},

	data: function( elem, name, data ) {
		elem = elem == window ?
			windowData :
			elem;

		var id = elem[ expando ];

		if ( !id )
			id = elem[ expando ] = ++uuid;

		if ( name && !jQuery.cache[ id ] )
			jQuery.cache[ id ] = {};

		if ( data !== undefined )
			jQuery.cache[ id ][ name ] = data;

		return name ?
			jQuery.cache[ id ][ name ] :
			id;
	},

	removeData: function( elem, name ) {
		elem = elem == window ?
			windowData :
			elem;

		var id = elem[ expando ];

		if ( name ) {
			if ( jQuery.cache[ id ] ) {
				delete jQuery.cache[ id ][ name ];

				name = "";

				for ( name in jQuery.cache[ id ] )
					break;

				if ( !name )
					jQuery.removeData( elem );
			}

		} else {
			try {
				delete elem[ expando ];
			} catch(e){
				if ( elem.removeAttribute )
					elem.removeAttribute( expando );
			}

			delete jQuery.cache[ id ];
		}
	},
	queue: function( elem, type, data ) {
		if ( elem ){

			type = (type || "fx") + "queue";

			var q = jQuery.data( elem, type );

			if ( !q || jQuery.isArray(data) )
				q = jQuery.data( elem, type, jQuery.makeArray(data) );
			else if( data )
				q.push( data );

		}
		return q;
	},

	dequeue: function( elem, type ){
		var queue = jQuery.queue( elem, type ),
			fn = queue.shift();

		if( !type || type === "fx" )
			fn = queue[0];

		if( fn !== undefined )
			fn.call(elem);
	}
});

jQuery.fn.extend({
	data: function( key, value ){
		var parts = key.split(".");
		parts[1] = parts[1] ? "." + parts[1] : "";

		if ( value === undefined ) {
			var data = this.triggerHandler("getData" + parts[1] + "!", [parts[0]]);

			if ( data === undefined && this.length )
				data = jQuery.data( this[0], key );

			return data === undefined && parts[1] ?
				this.data( parts[0] ) :
				data;
		} else
			return this.trigger("setData" + parts[1] + "!", [parts[0], value]).each(function(){
				jQuery.data( this, key, value );
			});
	},

	removeData: function( key ){
		return this.each(function(){
			jQuery.removeData( this, key );
		});
	},
	queue: function(type, data){
		if ( typeof type !== "string" ) {
			data = type;
			type = "fx";
		}

		if ( data === undefined )
			return jQuery.queue( this[0], type );

		return this.each(function(){
			var queue = jQuery.queue( this, type, data );

			 if( type == "fx" && queue.length == 1 )
				queue[0].call(this);
		});
	},
	dequeue: function(type){
		return this.each(function(){
			jQuery.dequeue( this, type );
		});
	}
});/*!
 * Sizzle CSS Selector Engine - v0.9.3
 *  Copyright 2009, The Dojo Foundation
 *  Released under the MIT, BSD, and GPL Licenses.
 *  More information: http://sizzlejs.com/
 */
(function(){

var chunker = /((?:\((?:\([^()]+\)|[^()]+)+\)|\[(?:\[[^[\]]*\]|['"][^'"]*['"]|[^[\]'"]+)+\]|\\.|[^ >+~,(\[\\]+)+|[>+~])(\s*,\s*)?/g,
	done = 0,
	toString = Object.prototype.toString;

var Sizzle = function(selector, context, results, seed) {
	results = results || [];
	context = context || document;

	if ( context.nodeType !== 1 && context.nodeType !== 9 )
		return [];

	if ( !selector || typeof selector !== "string" ) {
		return results;
	}

	var parts = [], m, set, checkSet, check, mode, extra, prune = true;

	chunker.lastIndex = 0;

	while ( (m = chunker.exec(selector)) !== null ) {
		parts.push( m[1] );

		if ( m[2] ) {
			extra = RegExp.rightContext;
			break;
		}
	}

	if ( parts.length > 1 && origPOS.exec( selector ) ) {
		if ( parts.length === 2 && Expr.relative[ parts[0] ] ) {
			set = posProcess( parts[0] + parts[1], context );
		} else {
			set = Expr.relative[ parts[0] ] ?
				[ context ] :
				Sizzle( parts.shift(), context );

			while ( parts.length ) {
				selector = parts.shift();

				if ( Expr.relative[ selector ] )
					selector += parts.shift();

				set = posProcess( selector, set );
			}
		}
	} else {
		var ret = seed ?
			{ expr: parts.pop(), set: makeArray(seed) } :
			Sizzle.find( parts.pop(), parts.length === 1 && context.parentNode ? context.parentNode : context, isXML(context) );
		set = Sizzle.filter( ret.expr, ret.set );

		if ( parts.length > 0 ) {
			checkSet = makeArray(set);
		} else {
			prune = false;
		}

		while ( parts.length ) {
			var cur = parts.pop(), pop = cur;

			if ( !Expr.relative[ cur ] ) {
				cur = "";
			} else {
				pop = parts.pop();
			}

			if ( pop == null ) {
				pop = context;
			}

			Expr.relative[ cur ]( checkSet, pop, isXML(context) );
		}
	}

	if ( !checkSet ) {
		checkSet = set;
	}

	if ( !checkSet ) {
		throw "Syntax error, unrecognized expression: " + (cur || selector);
	}

	if ( toString.call(checkSet) === "[object Array]" ) {
		if ( !prune ) {
			results.push.apply( results, checkSet );
		} else if ( context.nodeType === 1 ) {
			for ( var i = 0; checkSet[i] != null; i++ ) {
				if ( checkSet[i] && (checkSet[i] === true || checkSet[i].nodeType === 1 && contains(context, checkSet[i])) ) {
					results.push( set[i] );
				}
			}
		} else {
			for ( var i = 0; checkSet[i] != null; i++ ) {
				if ( checkSet[i] && checkSet[i].nodeType === 1 ) {
					results.push( set[i] );
				}
			}
		}
	} else {
		makeArray( checkSet, results );
	}

	if ( extra ) {
		Sizzle( extra, context, results, seed );

		if ( sortOrder ) {
			hasDuplicate = false;
			results.sort(sortOrder);

			if ( hasDuplicate ) {
				for ( var i = 1; i < results.length; i++ ) {
					if ( results[i] === results[i-1] ) {
						results.splice(i--, 1);
					}
				}
			}
		}
	}

	return results;
};

Sizzle.matches = function(expr, set){
	return Sizzle(expr, null, null, set);
};

Sizzle.find = function(expr, context, isXML){
	var set, match;

	if ( !expr ) {
		return [];
	}

	for ( var i = 0, l = Expr.order.length; i < l; i++ ) {
		var type = Expr.order[i], match;

		if ( (match = Expr.match[ type ].exec( expr )) ) {
			var left = RegExp.leftContext;

			if ( left.substr( left.length - 1 ) !== "\\" ) {
				match[1] = (match[1] || "").replace(/\\/g, "");
				set = Expr.find[ type ]( match, context, isXML );
				if ( set != null ) {
					expr = expr.replace( Expr.match[ type ], "" );
					break;
				}
			}
		}
	}

	if ( !set ) {
		set = context.getElementsByTagName("*");
	}

	return {set: set, expr: expr};
};

Sizzle.filter = function(expr, set, inplace, not){
	var old = expr, result = [], curLoop = set, match, anyFound,
		isXMLFilter = set && set[0] && isXML(set[0]);

	while ( expr && set.length ) {
		for ( var type in Expr.filter ) {
			if ( (match = Expr.match[ type ].exec( expr )) != null ) {
				var filter = Expr.filter[ type ], found, item;
				anyFound = false;

				if ( curLoop == result ) {
					result = [];
				}

				if ( Expr.preFilter[ type ] ) {
					match = Expr.preFilter[ type ]( match, curLoop, inplace, result, not, isXMLFilter );

					if ( !match ) {
						anyFound = found = true;
					} else if ( match === true ) {
						continue;
					}
				}

				if ( match ) {
					for ( var i = 0; (item = curLoop[i]) != null; i++ ) {
						if ( item ) {
							found = filter( item, match, i, curLoop );
							var pass = not ^ !!found;

							if ( inplace && found != null ) {
								if ( pass ) {
									anyFound = true;
								} else {
									curLoop[i] = false;
								}
							} else if ( pass ) {
								result.push( item );
								anyFound = true;
							}
						}
					}
				}

				if ( found !== undefined ) {
					if ( !inplace ) {
						curLoop = result;
					}

					expr = expr.replace( Expr.match[ type ], "" );

					if ( !anyFound ) {
						return [];
					}

					break;
				}
			}
		}

		if ( expr == old ) {
			if ( anyFound == null ) {
				throw "Syntax error, unrecognized expression: " + expr;
			} else {
				break;
			}
		}

		old = expr;
	}

	return curLoop;
};

var Expr = Sizzle.selectors = {
	order: [ "ID", "NAME", "TAG" ],
	match: {
		ID: /#((?:[\w\u00c0-\uFFFF_-]|\\.)+)/,
		CLASS: /\.((?:[\w\u00c0-\uFFFF_-]|\\.)+)/,
		NAME: /\[name=['"]*((?:[\w\u00c0-\uFFFF_-]|\\.)+)['"]*\]/,
		ATTR: /\[\s*((?:[\w\u00c0-\uFFFF_-]|\\.)+)\s*(?:(\S?=)\s*(['"]*)(.*?)\3|)\s*\]/,
		TAG: /^((?:[\w\u00c0-\uFFFF\*_-]|\\.)+)/,
		CHILD: /:(only|nth|last|first)-child(?:\((even|odd|[\dn+-]*)\))?/,
		POS: /:(nth|eq|gt|lt|first|last|even|odd)(?:\((\d*)\))?(?=[^-]|$)/,
		PSEUDO: /:((?:[\w\u00c0-\uFFFF_-]|\\.)+)(?:\((['"]*)((?:\([^\)]+\)|[^\2\(\)]*)+)\2\))?/
	},
	attrMap: {
		"class": "className",
		"for": "htmlFor"
	},
	attrHandle: {
		href: function(elem){
			return elem.getAttribute("href");
		}
	},
	relative: {
		"+": function(checkSet, part, isXML){
			var isPartStr = typeof part === "string",
				isTag = isPartStr && !/\W/.test(part),
				isPartStrNotTag = isPartStr && !isTag;

			if ( isTag && !isXML ) {
				part = part.toUpperCase();
			}

			for ( var i = 0, l = checkSet.length, elem; i < l; i++ ) {
				if ( (elem = checkSet[i]) ) {
					while ( (elem = elem.previousSibling) && elem.nodeType !== 1 ) {}

					checkSet[i] = isPartStrNotTag || elem && elem.nodeName === part ?
						elem || false :
						elem === part;
				}
			}

			if ( isPartStrNotTag ) {
				Sizzle.filter( part, checkSet, true );
			}
		},
		">": function(checkSet, part, isXML){
			var isPartStr = typeof part === "string";

			if ( isPartStr && !/\W/.test(part) ) {
				part = isXML ? part : part.toUpperCase();

				for ( var i = 0, l = checkSet.length; i < l; i++ ) {
					var elem = checkSet[i];
					if ( elem ) {
						var parent = elem.parentNode;
						checkSet[i] = parent.nodeName === part ? parent : false;
					}
				}
			} else {
				for ( var i = 0, l = checkSet.length; i < l; i++ ) {
					var elem = checkSet[i];
					if ( elem ) {
						checkSet[i] = isPartStr ?
							elem.parentNode :
							elem.parentNode === part;
					}
				}

				if ( isPartStr ) {
					Sizzle.filter( part, checkSet, true );
				}
			}
		},
		"": function(checkSet, part, isXML){
			var doneName = done++, checkFn = dirCheck;

			if ( !part.match(/\W/) ) {
				var nodeCheck = part = isXML ? part : part.toUpperCase();
				checkFn = dirNodeCheck;
			}

			checkFn("parentNode", part, doneName, checkSet, nodeCheck, isXML);
		},
		"~": function(checkSet, part, isXML){
			var doneName = done++, checkFn = dirCheck;

			if ( typeof part === "string" && !part.match(/\W/) ) {
				var nodeCheck = part = isXML ? part : part.toUpperCase();
				checkFn = dirNodeCheck;
			}

			checkFn("previousSibling", part, doneName, checkSet, nodeCheck, isXML);
		}
	},
	find: {
		ID: function(match, context, isXML){
			if ( typeof context.getElementById !== "undefined" && !isXML ) {
				var m = context.getElementById(match[1]);
				return m ? [m] : [];
			}
		},
		NAME: function(match, context, isXML){
			if ( typeof context.getElementsByName !== "undefined" ) {
				var ret = [], results = context.getElementsByName(match[1]);

				for ( var i = 0, l = results.length; i < l; i++ ) {
					if ( results[i].getAttribute("name") === match[1] ) {
						ret.push( results[i] );
					}
				}

				return ret.length === 0 ? null : ret;
			}
		},
		TAG: function(match, context){
			return context.getElementsByTagName(match[1]);
		}
	},
	preFilter: {
		CLASS: function(match, curLoop, inplace, result, not, isXML){
			match = " " + match[1].replace(/\\/g, "") + " ";

			if ( isXML ) {
				return match;
			}

			for ( var i = 0, elem; (elem = curLoop[i]) != null; i++ ) {
				if ( elem ) {
					if ( not ^ (elem.className && (" " + elem.className + " ").indexOf(match) >= 0) ) {
						if ( !inplace )
							result.push( elem );
					} else if ( inplace ) {
						curLoop[i] = false;
					}
				}
			}

			return false;
		},
		ID: function(match){
			return match[1].replace(/\\/g, "");
		},
		TAG: function(match, curLoop){
			for ( var i = 0; curLoop[i] === false; i++ ){}
			return curLoop[i] && isXML(curLoop[i]) ? match[1] : match[1].toUpperCase();
		},
		CHILD: function(match){
			if ( match[1] == "nth" ) {
				var test = /(-?)(\d*)n((?:\+|-)?\d*)/.exec(
					match[2] == "even" && "2n" || match[2] == "odd" && "2n+1" ||
					!/\D/.test( match[2] ) && "0n+" + match[2] || match[2]);

				match[2] = (test[1] + (test[2] || 1)) - 0;
				match[3] = test[3] - 0;
			}

			match[0] = done++;

			return match;
		},
		ATTR: function(match, curLoop, inplace, result, not, isXML){
			var name = match[1].replace(/\\/g, "");

			if ( !isXML && Expr.attrMap[name] ) {
				match[1] = Expr.attrMap[name];
			}

			if ( match[2] === "~=" ) {
				match[4] = " " + match[4] + " ";
			}

			return match;
		},
		PSEUDO: function(match, curLoop, inplace, result, not){
			if ( match[1] === "not" ) {
				if ( match[3].match(chunker).length > 1 || /^\w/.test(match[3]) ) {
					match[3] = Sizzle(match[3], null, null, curLoop);
				} else {
					var ret = Sizzle.filter(match[3], curLoop, inplace, true ^ not);
					if ( !inplace ) {
						result.push.apply( result, ret );
					}
					return false;
				}
			} else if ( Expr.match.POS.test( match[0] ) || Expr.match.CHILD.test( match[0] ) ) {
				return true;
			}

			return match;
		},
		POS: function(match){
			match.unshift( true );
			return match;
		}
	},
	filters: {
		enabled: function(elem){
			return elem.disabled === false && elem.type !== "hidden";
		},
		disabled: function(elem){
			return elem.disabled === true;
		},
		checked: function(elem){
			return elem.checked === true;
		},
		selected: function(elem){
			elem.parentNode.selectedIndex;
			return elem.selected === true;
		},
		parent: function(elem){
			return !!elem.firstChild;
		},
		empty: function(elem){
			return !elem.firstChild;
		},
		has: function(elem, i, match){
			return !!Sizzle( match[3], elem ).length;
		},
		header: function(elem){
			return /h\d/i.test( elem.nodeName );
		},
		text: function(elem){
			return "text" === elem.type;
		},
		radio: function(elem){
			return "radio" === elem.type;
		},
		checkbox: function(elem){
			return "checkbox" === elem.type;
		},
		file: function(elem){
			return "file" === elem.type;
		},
		password: function(elem){
			return "password" === elem.type;
		},
		submit: function(elem){
			return "submit" === elem.type;
		},
		image: function(elem){
			return "image" === elem.type;
		},
		reset: function(elem){
			return "reset" === elem.type;
		},
		button: function(elem){
			return "button" === elem.type || elem.nodeName.toUpperCase() === "BUTTON";
		},
		input: function(elem){
			return /input|select|textarea|button/i.test(elem.nodeName);
		}
	},
	setFilters: {
		first: function(elem, i){
			return i === 0;
		},
		last: function(elem, i, match, array){
			return i === array.length - 1;
		},
		even: function(elem, i){
			return i % 2 === 0;
		},
		odd: function(elem, i){
			return i % 2 === 1;
		},
		lt: function(elem, i, match){
			return i < match[3] - 0;
		},
		gt: function(elem, i, match){
			return i > match[3] - 0;
		},
		nth: function(elem, i, match){
			return match[3] - 0 == i;
		},
		eq: function(elem, i, match){
			return match[3] - 0 == i;
		}
	},
	filter: {
		PSEUDO: function(elem, match, i, array){
			var name = match[1], filter = Expr.filters[ name ];

			if ( filter ) {
				return filter( elem, i, match, array );
			} else if ( name === "contains" ) {
				return (elem.textContent || elem.innerText || "").indexOf(match[3]) >= 0;
			} else if ( name === "not" ) {
				var not = match[3];

				for ( var i = 0, l = not.length; i < l; i++ ) {
					if ( not[i] === elem ) {
						return false;
					}
				}

				return true;
			}
		},
		CHILD: function(elem, match){
			var type = match[1], node = elem;
			switch (type) {
				case 'only':
				case 'first':
					while (node = node.previousSibling)  {
						if ( node.nodeType === 1 ) return false;
					}
					if ( type == 'first') return true;
					node = elem;
				case 'last':
					while (node = node.nextSibling)  {
						if ( node.nodeType === 1 ) return false;
					}
					return true;
				case 'nth':
					var first = match[2], last = match[3];

					if ( first == 1 && last == 0 ) {
						return true;
					}

					var doneName = match[0],
						parent = elem.parentNode;

					if ( parent && (parent.sizcache !== doneName || !elem.nodeIndex) ) {
						var count = 0;
						for ( node = parent.firstChild; node; node = node.nextSibling ) {
							if ( node.nodeType === 1 ) {
								node.nodeIndex = ++count;
							}
						}
						parent.sizcache = doneName;
					}

					var diff = elem.nodeIndex - last;
					if ( first == 0 ) {
						return diff == 0;
					} else {
						return ( diff % first == 0 && diff / first >= 0 );
					}
			}
		},
		ID: function(elem, match){
			return elem.nodeType === 1 && elem.getAttribute("id") === match;
		},
		TAG: function(elem, match){
			return (match === "*" && elem.nodeType === 1) || elem.nodeName === match;
		},
		CLASS: function(elem, match){
			return (" " + (elem.className || elem.getAttribute("class")) + " ")
				.indexOf( match ) > -1;
		},
		ATTR: function(elem, match){
			var name = match[1],
				result = Expr.attrHandle[ name ] ?
					Expr.attrHandle[ name ]( elem ) :
					elem[ name ] != null ?
						elem[ name ] :
						elem.getAttribute( name ),
				value = result + "",
				type = match[2],
				check = match[4];

			return result == null ?
				type === "!=" :
				type === "=" ?
				value === check :
				type === "*=" ?
				value.indexOf(check) >= 0 :
				type === "~=" ?
				(" " + value + " ").indexOf(check) >= 0 :
				!check ?
				value && result !== false :
				type === "!=" ?
				value != check :
				type === "^=" ?
				value.indexOf(check) === 0 :
				type === "$=" ?
				value.substr(value.length - check.length) === check :
				type === "|=" ?
				value === check || value.substr(0, check.length + 1) === check + "-" :
				false;
		},
		POS: function(elem, match, i, array){
			var name = match[2], filter = Expr.setFilters[ name ];

			if ( filter ) {
				return filter( elem, i, match, array );
			}
		}
	}
};

var origPOS = Expr.match.POS;

for ( var type in Expr.match ) {
	Expr.match[ type ] = RegExp( Expr.match[ type ].source + /(?![^\[]*\])(?![^\(]*\))/.source );
}

var makeArray = function(array, results) {
	array = Array.prototype.slice.call( array );

	if ( results ) {
		results.push.apply( results, array );
		return results;
	}

	return array;
};

try {
	Array.prototype.slice.call( document.documentElement.childNodes );

} catch(e){
	makeArray = function(array, results) {
		var ret = results || [];

		if ( toString.call(array) === "[object Array]" ) {
			Array.prototype.push.apply( ret, array );
		} else {
			if ( typeof array.length === "number" ) {
				for ( var i = 0, l = array.length; i < l; i++ ) {
					ret.push( array[i] );
				}
			} else {
				for ( var i = 0; array[i]; i++ ) {
					ret.push( array[i] );
				}
			}
		}

		return ret;
	};
}

var sortOrder;

if ( document.documentElement.compareDocumentPosition ) {
	sortOrder = function( a, b ) {
		var ret = a.compareDocumentPosition(b) & 4 ? -1 : a === b ? 0 : 1;
		if ( ret === 0 ) {
			hasDuplicate = true;
		}
		return ret;
	};
} else if ( "sourceIndex" in document.documentElement ) {
	sortOrder = function( a, b ) {
		var ret = a.sourceIndex - b.sourceIndex;
		if ( ret === 0 ) {
			hasDuplicate = true;
		}
		return ret;
	};
} else if ( document.createRange ) {
	sortOrder = function( a, b ) {
		var aRange = a.ownerDocument.createRange(), bRange = b.ownerDocument.createRange();
		aRange.selectNode(a);
		aRange.collapse(true);
		bRange.selectNode(b);
		bRange.collapse(true);
		var ret = aRange.compareBoundaryPoints(Range.START_TO_END, bRange);
		if ( ret === 0 ) {
			hasDuplicate = true;
		}
		return ret;
	};
}

(function(){
	var form = document.createElement("form"),
		id = "script" + (new Date).getTime();
	form.innerHTML = "<input name='" + id + "'/>";

	var root = document.documentElement;
	root.insertBefore( form, root.firstChild );

	if ( !!document.getElementById( id ) ) {
		Expr.find.ID = function(match, context, isXML){
			if ( typeof context.getElementById !== "undefined" && !isXML ) {
				var m = context.getElementById(match[1]);
				return m ? m.id === match[1] || typeof m.getAttributeNode !== "undefined" && m.getAttributeNode("id").nodeValue === match[1] ? [m] : undefined : [];
			}
		};

		Expr.filter.ID = function(elem, match){
			var node = typeof elem.getAttributeNode !== "undefined" && elem.getAttributeNode("id");
			return elem.nodeType === 1 && node && node.nodeValue === match;
		};
	}

	root.removeChild( form );
})();

(function(){

	var div = document.createElement("div");
	div.appendChild( document.createComment("") );

	if ( div.getElementsByTagName("*").length > 0 ) {
		Expr.find.TAG = function(match, context){
			var results = context.getElementsByTagName(match[1]);

			if ( match[1] === "*" ) {
				var tmp = [];

				for ( var i = 0; results[i]; i++ ) {
					if ( results[i].nodeType === 1 ) {
						tmp.push( results[i] );
					}
				}

				results = tmp;
			}

			return results;
		};
	}

	div.innerHTML = "<a href='#'></a>";
	if ( div.firstChild && typeof div.firstChild.getAttribute !== "undefined" &&
			div.firstChild.getAttribute("href") !== "#" ) {
		Expr.attrHandle.href = function(elem){
			return elem.getAttribute("href", 2);
		};
	}
})();

if ( document.querySelectorAll ) (function(){
	var oldSizzle = Sizzle, div = document.createElement("div");
	div.innerHTML = "<p class='TEST'></p>";

	if ( div.querySelectorAll && div.querySelectorAll(".TEST").length === 0 ) {
		return;
	}

	Sizzle = function(query, context, extra, seed){
		context = context || document;

		if ( !seed && context.nodeType === 9 && !isXML(context) ) {
			try {
				return makeArray( context.querySelectorAll(query), extra );
			} catch(e){}
		}

		return oldSizzle(query, context, extra, seed);
	};

	Sizzle.find = oldSizzle.find;
	Sizzle.filter = oldSizzle.filter;
	Sizzle.selectors = oldSizzle.selectors;
	Sizzle.matches = oldSizzle.matches;
})();

if ( document.getElementsByClassName && document.documentElement.getElementsByClassName ) (function(){
	var div = document.createElement("div");
	div.innerHTML = "<div class='test e'></div><div class='test'></div>";

	if ( div.getElementsByClassName("e").length === 0 )
		return;

	div.lastChild.className = "e";

	if ( div.getElementsByClassName("e").length === 1 )
		return;

	Expr.order.splice(1, 0, "CLASS");
	Expr.find.CLASS = function(match, context, isXML) {
		if ( typeof context.getElementsByClassName !== "undefined" && !isXML ) {
			return context.getElementsByClassName(match[1]);
		}
	};
})();

function dirNodeCheck( dir, cur, doneName, checkSet, nodeCheck, isXML ) {
	var sibDir = dir == "previousSibling" && !isXML;
	for ( var i = 0, l = checkSet.length; i < l; i++ ) {
		var elem = checkSet[i];
		if ( elem ) {
			if ( sibDir && elem.nodeType === 1 ){
				elem.sizcache = doneName;
				elem.sizset = i;
			}
			elem = elem[dir];
			var match = false;

			while ( elem ) {
				if ( elem.sizcache === doneName ) {
					match = checkSet[elem.sizset];
					break;
				}

				if ( elem.nodeType === 1 && !isXML ){
					elem.sizcache = doneName;
					elem.sizset = i;
				}

				if ( elem.nodeName === cur ) {
					match = elem;
					break;
				}

				elem = elem[dir];
			}

			checkSet[i] = match;
		}
	}
}

function dirCheck( dir, cur, doneName, checkSet, nodeCheck, isXML ) {
	var sibDir = dir == "previousSibling" && !isXML;
	for ( var i = 0, l = checkSet.length; i < l; i++ ) {
		var elem = checkSet[i];
		if ( elem ) {
			if ( sibDir && elem.nodeType === 1 ) {
				elem.sizcache = doneName;
				elem.sizset = i;
			}
			elem = elem[dir];
			var match = false;

			while ( elem ) {
				if ( elem.sizcache === doneName ) {
					match = checkSet[elem.sizset];
					break;
				}

				if ( elem.nodeType === 1 ) {
					if ( !isXML ) {
						elem.sizcache = doneName;
						elem.sizset = i;
					}
					if ( typeof cur !== "string" ) {
						if ( elem === cur ) {
							match = true;
							break;
						}

					} else if ( Sizzle.filter( cur, [elem] ).length > 0 ) {
						match = elem;
						break;
					}
				}

				elem = elem[dir];
			}

			checkSet[i] = match;
		}
	}
}

var contains = document.compareDocumentPosition ?  function(a, b){
	return a.compareDocumentPosition(b) & 16;
} : function(a, b){
	return a !== b && (a.contains ? a.contains(b) : true);
};

var isXML = function(elem){
	return elem.nodeType === 9 && elem.documentElement.nodeName !== "HTML" ||
		!!elem.ownerDocument && isXML( elem.ownerDocument );
};

var posProcess = function(selector, context){
	var tmpSet = [], later = "", match,
		root = context.nodeType ? [context] : context;

	while ( (match = Expr.match.PSEUDO.exec( selector )) ) {
		later += match[0];
		selector = selector.replace( Expr.match.PSEUDO, "" );
	}

	selector = Expr.relative[selector] ? selector + "*" : selector;

	for ( var i = 0, l = root.length; i < l; i++ ) {
		Sizzle( selector, root[i], tmpSet );
	}

	return Sizzle.filter( later, tmpSet );
};

jQuery.find = Sizzle;
jQuery.filter = Sizzle.filter;
jQuery.expr = Sizzle.selectors;
jQuery.expr[":"] = jQuery.expr.filters;

Sizzle.selectors.filters.hidden = function(elem){
	return elem.offsetWidth === 0 || elem.offsetHeight === 0;
};

Sizzle.selectors.filters.visible = function(elem){
	return elem.offsetWidth > 0 || elem.offsetHeight > 0;
};

Sizzle.selectors.filters.animated = function(elem){
	return jQuery.grep(jQuery.timers, function(fn){
		return elem === fn.elem;
	}).length;
};

jQuery.multiFilter = function( expr, elems, not ) {
	if ( not ) {
		expr = ":not(" + expr + ")";
	}

	return Sizzle.matches(expr, elems);
};

jQuery.dir = function( elem, dir ){
	var matched = [], cur = elem[dir];
	while ( cur && cur != document ) {
		if ( cur.nodeType == 1 )
			matched.push( cur );
		cur = cur[dir];
	}
	return matched;
};

jQuery.nth = function(cur, result, dir, elem){
	result = result || 1;
	var num = 0;

	for ( ; cur; cur = cur[dir] )
		if ( cur.nodeType == 1 && ++num == result )
			break;

	return cur;
};

jQuery.sibling = function(n, elem){
	var r = [];

	for ( ; n; n = n.nextSibling ) {
		if ( n.nodeType == 1 && n != elem )
			r.push( n );
	}

	return r;
};

return;

window.Sizzle = Sizzle;

})();
/*
 * A number of helper functions used for managing events.
 * Many of the ideas behind this code originated from
 * Dean Edwards' addEvent library.
 */
jQuery.event = {

	add: function(elem, types, handler, data) {
		if ( elem.nodeType == 3 || elem.nodeType == 8 )
			return;

		if ( elem.setInterval && elem != window )
			elem = window;

		if ( !handler.guid )
			handler.guid = this.guid++;

		if ( data !== undefined ) {
			var fn = handler;

			handler = this.proxy( fn );

			handler.data = data;
		}

		var events = jQuery.data(elem, "events") || jQuery.data(elem, "events", {}),
			handle = jQuery.data(elem, "handle") || jQuery.data(elem, "handle", function(){
				return typeof jQuery !== "undefined" && !jQuery.event.triggered ?
					jQuery.event.handle.apply(arguments.callee.elem, arguments) :
					undefined;
			});
		handle.elem = elem;

		jQuery.each(types.split(/\s+/), function(index, type) {
			var namespaces = type.split(".");
			type = namespaces.shift();
			handler.type = namespaces.slice().sort().join(".");

			var handlers = events[type];

			if ( jQuery.event.specialAll[type] )
				jQuery.event.specialAll[type].setup.call(elem, data, namespaces);

			if (!handlers) {
				handlers = events[type] = {};

				if ( !jQuery.event.special[type] || jQuery.event.special[type].setup.call(elem, data, namespaces) === false ) {
					if (elem.addEventListener)
						elem.addEventListener(type, handle, false);
					else if (elem.attachEvent)
						elem.attachEvent("on" + type, handle);
				}
			}

			handlers[handler.guid] = handler;

			jQuery.event.global[type] = true;
		});

		elem = null;
	},

	guid: 1,
	global: {},

	remove: function(elem, types, handler) {
		if ( elem.nodeType == 3 || elem.nodeType == 8 )
			return;

		var events = jQuery.data(elem, "events"), ret, index;

		if ( events ) {
			if ( types === undefined || (typeof types === "string" && types.charAt(0) == ".") )
				for ( var type in events )
					this.remove( elem, type + (types || "") );
			else {
				if ( types.type ) {
					handler = types.handler;
					types = types.type;
				}

				jQuery.each(types.split(/\s+/), function(index, type){
					var namespaces = type.split(".");
					type = namespaces.shift();
					var namespace = RegExp("(^|\\.)" + namespaces.slice().sort().join(".*\\.") + "(\\.|$)");

					if ( events[type] ) {
						if ( handler )
							delete events[type][handler.guid];

						else
							for ( var handle in events[type] )
								if ( namespace.test(events[type][handle].type) )
									delete events[type][handle];

						if ( jQuery.event.specialAll[type] )
							jQuery.event.specialAll[type].teardown.call(elem, namespaces);

						for ( ret in events[type] ) break;
						if ( !ret ) {
							if ( !jQuery.event.special[type] || jQuery.event.special[type].teardown.call(elem, namespaces) === false ) {
								if (elem.removeEventListener)
									elem.removeEventListener(type, jQuery.data(elem, "handle"), false);
								else if (elem.detachEvent)
									elem.detachEvent("on" + type, jQuery.data(elem, "handle"));
							}
							ret = null;
							delete events[type];
						}
					}
				});
			}

			for ( ret in events ) break;
			if ( !ret ) {
				var handle = jQuery.data( elem, "handle" );
				if ( handle ) handle.elem = null;
				jQuery.removeData( elem, "events" );
				jQuery.removeData( elem, "handle" );
			}
		}
	},

	trigger: function( event, data, elem, bubbling ) {
		var type = event.type || event;

		if( !bubbling ){
			event = typeof event === "object" ?
				event[expando] ? event :
				jQuery.extend( jQuery.Event(type), event ) :
				jQuery.Event(type);

			if ( type.indexOf("!") >= 0 ) {
				event.type = type = type.slice(0, -1);
				event.exclusive = true;
			}

			if ( !elem ) {
				event.stopPropagation();
				if ( this.global[type] )
					jQuery.each( jQuery.cache, function(){
						if ( this.events && this.events[type] )
							jQuery.event.trigger( event, data, this.handle.elem );
					});
			}


			if ( !elem || elem.nodeType == 3 || elem.nodeType == 8 )
				return undefined;

			event.result = undefined;
			event.target = elem;

			data = jQuery.makeArray(data);
			data.unshift( event );
		}

		event.currentTarget = elem;

		var handle = jQuery.data(elem, "handle");
		if ( handle )
			handle.apply( elem, data );

		if ( (!elem[type] || (jQuery.nodeName(elem, 'a') && type == "click")) && elem["on"+type] && elem["on"+type].apply( elem, data ) === false )
			event.result = false;

		if ( !bubbling && elem[type] && !event.isDefaultPrevented() && !(jQuery.nodeName(elem, 'a') && type == "click") ) {
			this.triggered = true;
			try {
				elem[ type ]();
			} catch (e) {}
		}

		this.triggered = false;

		if ( !event.isPropagationStopped() ) {
			var parent = elem.parentNode || elem.ownerDocument;
			if ( parent )
				jQuery.event.trigger(event, data, parent, true);
		}
	},

	handle: function(event) {
		var all, handlers;

		event = arguments[0] = jQuery.event.fix( event || window.event );
		event.currentTarget = this;

		var namespaces = event.type.split(".");
		event.type = namespaces.shift();

		all = !namespaces.length && !event.exclusive;

		var namespace = RegExp("(^|\\.)" + namespaces.slice().sort().join(".*\\.") + "(\\.|$)");

		handlers = ( jQuery.data(this, "events") || {} )[event.type];

		for ( var j in handlers ) {
			var handler = handlers[j];

			if ( all || namespace.test(handler.type) ) {
				event.handler = handler;
				event.data = handler.data;

				var ret = handler.apply(this, arguments);

				if( ret !== undefined ){
					event.result = ret;
					if ( ret === false ) {
						event.preventDefault();
						event.stopPropagation();
					}
				}

				if( event.isImmediatePropagationStopped() )
					break;

			}
		}
	},

	props: "altKey attrChange attrName bubbles button cancelable charCode clientX clientY ctrlKey currentTarget data detail eventPhase fromElement handler keyCode metaKey newValue originalTarget pageX pageY prevValue relatedNode relatedTarget screenX screenY shiftKey srcElement target toElement view wheelDelta which".split(" "),

	fix: function(event) {
		if ( event[expando] )
			return event;

		var originalEvent = event;
		event = jQuery.Event( originalEvent );

		for ( var i = this.props.length, prop; i; ){
			prop = this.props[ --i ];
			event[ prop ] = originalEvent[ prop ];
		}

		if ( !event.target )
			event.target = event.srcElement || document; // Fixes #1925 where srcElement might not be defined either

		if ( event.target.nodeType == 3 )
			event.target = event.target.parentNode;

		if ( !event.relatedTarget && event.fromElement )
			event.relatedTarget = event.fromElement == event.target ? event.toElement : event.fromElement;

		if ( event.pageX == null && event.clientX != null ) {
			var doc = document.documentElement, body = document.body;
			event.pageX = event.clientX + (doc && doc.scrollLeft || body && body.scrollLeft || 0) - (doc.clientLeft || 0);
			event.pageY = event.clientY + (doc && doc.scrollTop || body && body.scrollTop || 0) - (doc.clientTop || 0);
		}

		if ( !event.which && ((event.charCode || event.charCode === 0) ? event.charCode : event.keyCode) )
			event.which = event.charCode || event.keyCode;

		if ( !event.metaKey && event.ctrlKey )
			event.metaKey = event.ctrlKey;

		if ( !event.which && event.button )
			event.which = (event.button & 1 ? 1 : ( event.button & 2 ? 3 : ( event.button & 4 ? 2 : 0 ) ));

		return event;
	},

	proxy: function( fn, proxy ){
		proxy = proxy || function(){ return fn.apply(this, arguments); };
		proxy.guid = fn.guid = fn.guid || proxy.guid || this.guid++;
		return proxy;
	},

	special: {
		ready: {
			setup: bindReady,
			teardown: function() {}
		}
	},

	specialAll: {
		live: {
			setup: function( selector, namespaces ){
				jQuery.event.add( this, namespaces[0], liveHandler );
			},
			teardown:  function( namespaces ){
				if ( namespaces.length ) {
					var remove = 0, name = RegExp("(^|\\.)" + namespaces[0] + "(\\.|$)");

					jQuery.each( (jQuery.data(this, "events").live || {}), function(){
						if ( name.test(this.type) )
							remove++;
					});

					if ( remove < 1 )
						jQuery.event.remove( this, namespaces[0], liveHandler );
				}
			}
		}
	}
};

jQuery.Event = function( src ){
	if( !this.preventDefault )
		return new jQuery.Event(src);

	if( src && src.type ){
		this.originalEvent = src;
		this.type = src.type;
	}else
		this.type = src;

	this.timeStamp = now();

	this[expando] = true;
};

function returnFalse(){
	return false;
}
function returnTrue(){
	return true;
}

jQuery.Event.prototype = {
	preventDefault: function() {
		this.isDefaultPrevented = returnTrue;

		var e = this.originalEvent;
		if( !e )
			return;
		if (e.preventDefault)
			e.preventDefault();
		e.returnValue = false;
	},
	stopPropagation: function() {
		this.isPropagationStopped = returnTrue;

		var e = this.originalEvent;
		if( !e )
			return;
		if (e.stopPropagation)
			e.stopPropagation();
		e.cancelBubble = true;
	},
	stopImmediatePropagation:function(){
		this.isImmediatePropagationStopped = returnTrue;
		this.stopPropagation();
	},
	isDefaultPrevented: returnFalse,
	isPropagationStopped: returnFalse,
	isImmediatePropagationStopped: returnFalse
};
var withinElement = function(event) {
	var parent = event.relatedTarget;
	while ( parent && parent != this )
		try { parent = parent.parentNode; }
		catch(e) { parent = this; }

	if( parent != this ){
		event.type = event.data;
		jQuery.event.handle.apply( this, arguments );
	}
};

jQuery.each({
	mouseover: 'mouseenter',
	mouseout: 'mouseleave'
}, function( orig, fix ){
	jQuery.event.special[ fix ] = {
		setup: function(){
			jQuery.event.add( this, orig, withinElement, fix );
		},
		teardown: function(){
			jQuery.event.remove( this, orig, withinElement );
		}
	};
});

jQuery.fn.extend({
	bind: function( type, data, fn ) {
		return type == "unload" ? this.one(type, data, fn) : this.each(function(){
			jQuery.event.add( this, type, fn || data, fn && data );
		});
	},

	one: function( type, data, fn ) {
		var one = jQuery.event.proxy( fn || data, function(event) {
			jQuery(this).unbind(event, one);
			return (fn || data).apply( this, arguments );
		});
		return this.each(function(){
			jQuery.event.add( this, type, one, fn && data);
		});
	},

	unbind: function( type, fn ) {
		return this.each(function(){
			jQuery.event.remove( this, type, fn );
		});
	},

	trigger: function( type, data ) {
		return this.each(function(){
			jQuery.event.trigger( type, data, this );
		});
	},

	triggerHandler: function( type, data ) {
		if( this[0] ){
			var event = jQuery.Event(type);
			event.preventDefault();
			event.stopPropagation();
			jQuery.event.trigger( event, data, this[0] );
			return event.result;
		}
	},

	toggle: function( fn ) {
		var args = arguments, i = 1;

		while( i < args.length )
			jQuery.event.proxy( fn, args[i++] );

		return this.click( jQuery.event.proxy( fn, function(event) {
			this.lastToggle = ( this.lastToggle || 0 ) % i;

			event.preventDefault();

			return args[ this.lastToggle++ ].apply( this, arguments ) || false;
		}));
	},

	hover: function(fnOver, fnOut) {
		return this.mouseenter(fnOver).mouseleave(fnOut);
	},

	ready: function(fn) {
		bindReady();

		if ( jQuery.isReady )
			fn.call( document, jQuery );

		else
			jQuery.readyList.push( fn );

		return this;
	},

	live: function( type, fn ){
		var proxy = jQuery.event.proxy( fn );
		proxy.guid += this.selector + type;

		jQuery(document).bind( liveConvert(type, this.selector), this.selector, proxy );

		return this;
	},

	die: function( type, fn ){
		jQuery(document).unbind( liveConvert(type, this.selector), fn ? { guid: fn.guid + this.selector + type } : null );
		return this;
	}
});

function liveHandler( event ){
	var check = RegExp("(^|\\.)" + event.type + "(\\.|$)"),
		stop = true,
		elems = [];

	jQuery.each(jQuery.data(this, "events").live || [], function(i, fn){
		if ( check.test(fn.type) ) {
			var elem = jQuery(event.target).closest(fn.data)[0];
			if ( elem )
				elems.push({ elem: elem, fn: fn });
		}
	});

	elems.sort(function(a,b) {
		return jQuery.data(a.elem, "closest") - jQuery.data(b.elem, "closest");
	});

	jQuery.each(elems, function(){
		if ( this.fn.call(this.elem, event, this.fn.data) === false )
			return (stop = false);
	});

	return stop;
}

function liveConvert(type, selector){
	return ["live", type, selector.replace(/\./g, "`").replace(/ /g, "|")].join(".");
}

jQuery.extend({
	isReady: false,
	readyList: [],
	ready: function() {
		if ( !jQuery.isReady ) {
			jQuery.isReady = true;

			if ( jQuery.readyList ) {
				jQuery.each( jQuery.readyList, function(){
					this.call( document, jQuery );
				});

				jQuery.readyList = null;
			}

			jQuery(document).triggerHandler("ready");
		}
	}
});

var readyBound = false;

function bindReady(){
	if ( readyBound ) return;
	readyBound = true;

	if ( document.addEventListener ) {
		document.addEventListener( "DOMContentLoaded", function(){
			document.removeEventListener( "DOMContentLoaded", arguments.callee, false );
			jQuery.ready();
		}, false );

	} else if ( document.attachEvent ) {
		document.attachEvent("onreadystatechange", function(){
			if ( document.readyState === "complete" ) {
				document.detachEvent( "onreadystatechange", arguments.callee );
				jQuery.ready();
			}
		});

		if ( document.documentElement.doScroll && window == window.top ) (function(){
			if ( jQuery.isReady ) return;

			try {
				document.documentElement.doScroll("left");
			} catch( error ) {
				setTimeout( arguments.callee, 0 );
				return;
			}

			jQuery.ready();
		})();
	}

	jQuery.event.add( window, "load", jQuery.ready );
}

jQuery.each( ("blur,focus,load,resize,scroll,unload,click,dblclick," +
	"mousedown,mouseup,mousemove,mouseover,mouseout,mouseenter,mouseleave," +
	"change,select,submit,keydown,keypress,keyup,error").split(","), function(i, name){

	jQuery.fn[name] = function(fn){
		return fn ? this.bind(name, fn) : this.trigger(name);
	};
});

jQuery( window ).bind( 'unload', function(){
	for ( var id in jQuery.cache )
		if ( id != 1 && jQuery.cache[ id ].handle )
			jQuery.event.remove( jQuery.cache[ id ].handle.elem );
});
(function(){

	jQuery.support = {};

	var root = document.documentElement,
		script = document.createElement("script"),
		div = document.createElement("div"),
		id = "script" + (new Date).getTime();

	div.style.display = "none";
	div.innerHTML = '   <link/><table></table><a href="/a" style="color:red;float:left;opacity:.5;">a</a><select><option>text</option></select><object><param/></object>';

	var all = div.getElementsByTagName("*"),
		a = div.getElementsByTagName("a")[0];

	if ( !all || !all.length || !a ) {
		return;
	}

	jQuery.support = {
		leadingWhitespace: div.firstChild.nodeType == 3,

		tbody: !div.getElementsByTagName("tbody").length,

		objectAll: !!div.getElementsByTagName("object")[0]
			.getElementsByTagName("*").length,

		htmlSerialize: !!div.getElementsByTagName("link").length,

		style: /red/.test( a.getAttribute("style") ),

		hrefNormalized: a.getAttribute("href") === "/a",

		opacity: a.style.opacity === "0.5",

		cssFloat: !!a.style.cssFloat,

		scriptEval: false,
		noCloneEvent: true,
		boxModel: null
	};

	script.type = "text/javascript";
	try {
		script.appendChild( document.createTextNode( "window." + id + "=1;" ) );
	} catch(e){}

	root.insertBefore( script, root.firstChild );

	if ( window[ id ] ) {
		jQuery.support.scriptEval = true;
		delete window[ id ];
	}

	root.removeChild( script );

	if ( div.attachEvent && div.fireEvent ) {
		div.attachEvent("onclick", function(){
			jQuery.support.noCloneEvent = false;
			div.detachEvent("onclick", arguments.callee);
		});
		div.cloneNode(true).fireEvent("onclick");
	}

	jQuery(function(){
		var div = document.createElement("div");
		div.style.width = div.style.paddingLeft = "1px";

		document.body.appendChild( div );
		jQuery.boxModel = jQuery.support.boxModel = div.offsetWidth === 2;
		document.body.removeChild( div ).style.display = 'none';
	});
})();

var styleFloat = jQuery.support.cssFloat ? "cssFloat" : "styleFloat";

jQuery.props = {
	"for": "htmlFor",
	"class": "className",
	"float": styleFloat,
	cssFloat: styleFloat,
	styleFloat: styleFloat,
	readonly: "readOnly",
	maxlength: "maxLength",
	cellspacing: "cellSpacing",
	rowspan: "rowSpan",
	tabindex: "tabIndex"
};
jQuery.fn.extend({
	_load: jQuery.fn.load,

	load: function( url, params, callback ) {
		if ( typeof url !== "string" )
			return this._load( url );

		var off = url.indexOf(" ");
		if ( off >= 0 ) {
			var selector = url.slice(off, url.length);
			url = url.slice(0, off);
		}

		var type = "GET";

		if ( params )
			if ( jQuery.isFunction( params ) ) {
				callback = params;
				params = null;

			} else if( typeof params === "object" ) {
				params = jQuery.param( params );
				type = "POST";
			}

		var self = this;

		jQuery.ajax({
			url: url,
			type: type,
			dataType: "html",
			data: params,
			complete: function(res, status){
				if ( status == "success" || status == "notmodified" )
					self.html( selector ?
						jQuery("<div/>")
							.append(res.responseText.replace(/<script(.|\s)*?\/script>/g, ""))

							.find(selector) :

						res.responseText );

				if( callback )
					self.each( callback, [res.responseText, status, res] );
			}
		});
		return this;
	},

	serialize: function() {
		return jQuery.param(this.serializeArray());
	},
	serializeArray: function() {
		return this.map(function(){
			return this.elements ? jQuery.makeArray(this.elements) : this;
		})
		.filter(function(){
			return this.name && !this.disabled &&
				(this.checked || /select|textarea/i.test(this.nodeName) ||
					/text|hidden|password|search/i.test(this.type));
		})
		.map(function(i, elem){
			var val = jQuery(this).val();
			return val == null ? null :
				jQuery.isArray(val) ?
					jQuery.map( val, function(val, i){
						return {name: elem.name, value: val};
					}) :
					{name: elem.name, value: val};
		}).get();
	}
});

jQuery.each( "ajaxStart,ajaxStop,ajaxComplete,ajaxError,ajaxSuccess,ajaxSend".split(","), function(i,o){
	jQuery.fn[o] = function(f){
		return this.bind(o, f);
	};
});

var jsc = now();

jQuery.extend({

	get: function( url, data, callback, type ) {
		if ( jQuery.isFunction( data ) ) {
			callback = data;
			data = null;
		}

		return jQuery.ajax({
			type: "GET",
			url: url,
			data: data,
			success: callback,
			dataType: type
		});
	},

	getScript: function( url, callback ) {
		return jQuery.get(url, null, callback, "script");
	},

	getJSON: function( url, data, callback ) {
		return jQuery.get(url, data, callback, "json");
	},

	post: function( url, data, callback, type ) {
		if ( jQuery.isFunction( data ) ) {
			callback = data;
			data = {};
		}

		return jQuery.ajax({
			type: "POST",
			url: url,
			data: data,
			success: callback,
			dataType: type
		});
	},

	ajaxSetup: function( settings ) {
		jQuery.extend( jQuery.ajaxSettings, settings );
	},

	ajaxSettings: {
		url: location.href,
		global: true,
		type: "GET",
		contentType: "application/x-www-form-urlencoded",
		processData: true,
		async: true,
		/*
		timeout: 0,
		data: null,
		username: null,
		password: null,
		*/
		xhr:function(){
			return window.ActiveXObject ? new ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest();
		},
		accepts: {
			xml: "application/xml, text/xml",
			html: "text/html",
			script: "text/javascript, application/javascript",
			json: "application/json, text/javascript",
			text: "text/plain",
			_default: "*/*"
		}
	},

	lastModified: {},

	ajax: function( s ) {
		s = jQuery.extend(true, s, jQuery.extend(true, {}, jQuery.ajaxSettings, s));

		var jsonp, jsre = /=\?(&|$)/g, status, data,
			type = s.type.toUpperCase();

		if ( s.data && s.processData && typeof s.data !== "string" )
			s.data = jQuery.param(s.data);

		if ( s.dataType == "jsonp" ) {
			if ( type == "GET" ) {
				if ( !s.url.match(jsre) )
					s.url += (s.url.match(/\?/) ? "&" : "?") + (s.jsonp || "callback") + "=?";
			} else if ( !s.data || !s.data.match(jsre) )
				s.data = (s.data ? s.data + "&" : "") + (s.jsonp || "callback") + "=?";
			s.dataType = "json";
		}

		if ( s.dataType == "json" && (s.data && s.data.match(jsre) || s.url.match(jsre)) ) {
			jsonp = "jsonp" + jsc++;

			if ( s.data )
				s.data = (s.data + "").replace(jsre, "=" + jsonp + "$1");
			s.url = s.url.replace(jsre, "=" + jsonp + "$1");

			s.dataType = "script";

			window[ jsonp ] = function(tmp){
				data = tmp;
				success();
				complete();
				window[ jsonp ] = undefined;
				try{ delete window[ jsonp ]; } catch(e){}
				if ( head )
					head.removeChild( script );
			};
		}

		if ( s.dataType == "script" && s.cache == null )
			s.cache = false;

		if ( s.cache === false && type == "GET" ) {
			var ts = now();
			var ret = s.url.replace(/(\?|&)_=.*?(&|$)/, "$1_=" + ts + "$2");
			s.url = ret + ((ret == s.url) ? (s.url.match(/\?/) ? "&" : "?") + "_=" + ts : "");
		}

		if ( s.data && type == "GET" ) {
			s.url += (s.url.match(/\?/) ? "&" : "?") + s.data;

			s.data = null;
		}

		if ( s.global && ! jQuery.active++ )
			jQuery.event.trigger( "ajaxStart" );

		var parts = /^(\w+:)?\/\/([^\/?#]+)/.exec( s.url );

		if ( s.dataType == "script" && type == "GET" && parts
			&& ( parts[1] && parts[1] != location.protocol || parts[2] != location.host )){

			var head = document.getElementsByTagName("head")[0];
			var script = document.createElement("script");
			script.src = s.url;
			if (s.scriptCharset)
				script.charset = s.scriptCharset;

			if ( !jsonp ) {
				var done = false;

				script.onload = script.onreadystatechange = function(){
					if ( !done && (!this.readyState ||
							this.readyState == "loaded" || this.readyState == "complete") ) {
						done = true;
						success();
						complete();

						script.onload = script.onreadystatechange = null;
						head.removeChild( script );
					}
				};
			}

			head.appendChild(script);

			return undefined;
		}

		var requestDone = false;

		var xhr = s.xhr();

		if( s.username )
			xhr.open(type, s.url, s.async, s.username, s.password);
		else
			xhr.open(type, s.url, s.async);

		try {
			if ( s.data )
				xhr.setRequestHeader("Content-Type", s.contentType);

			if ( s.ifModified )
				xhr.setRequestHeader("If-Modified-Since",
					jQuery.lastModified[s.url] || "Thu, 01 Jan 1970 00:00:00 GMT" );

			xhr.setRequestHeader("X-Requested-With", "XMLHttpRequest");

			xhr.setRequestHeader("Accept", s.dataType && s.accepts[ s.dataType ] ?
				s.accepts[ s.dataType ] + ", */*" :
				s.accepts._default );
		} catch(e){}

		if ( s.beforeSend && s.beforeSend(xhr, s) === false ) {
			if ( s.global && ! --jQuery.active )
				jQuery.event.trigger( "ajaxStop" );
			xhr.abort();
			return false;
		}

		if ( s.global )
			jQuery.event.trigger("ajaxSend", [xhr, s]);

		var onreadystatechange = function(isTimeout){
			if (xhr.readyState == 0) {
				if (ival) {
					clearInterval(ival);
					ival = null;
					if ( s.global && ! --jQuery.active )
						jQuery.event.trigger( "ajaxStop" );
				}
			} else if ( !requestDone && xhr && (xhr.readyState == 4 || isTimeout == "timeout") ) {
				requestDone = true;

				if (ival) {
					clearInterval(ival);
					ival = null;
				}

				status = isTimeout == "timeout" ? "timeout" :
					!jQuery.httpSuccess( xhr ) ? "error" :
					s.ifModified && jQuery.httpNotModified( xhr, s.url ) ? "notmodified" :
					"success";

				if ( status == "success" ) {
					try {
						data = jQuery.httpData( xhr, s.dataType, s );
					} catch(e) {
						status = "parsererror";
					}
				}

				if ( status == "success" ) {
					var modRes;
					try {
						modRes = xhr.getResponseHeader("Last-Modified");
					} catch(e) {} // swallow exception thrown by FF if header is not available

					if ( s.ifModified && modRes )
						jQuery.lastModified[s.url] = modRes;

					if ( !jsonp )
						success();
				} else
					jQuery.handleError(s, xhr, status);

				complete();

				if ( isTimeout )
					xhr.abort();

				if ( s.async )
					xhr = null;
			}
		};

		if ( s.async ) {
			var ival = setInterval(onreadystatechange, 13);

			if ( s.timeout > 0 )
				setTimeout(function(){
					if ( xhr && !requestDone )
						onreadystatechange( "timeout" );
				}, s.timeout);
		}

		try {
			xhr.send(s.data);
		} catch(e) {
			jQuery.handleError(s, xhr, null, e);
		}

		if ( !s.async )
			onreadystatechange();

		function success(){
			if ( s.success )
				s.success( data, status );

			if ( s.global )
				jQuery.event.trigger( "ajaxSuccess", [xhr, s] );
		}

		function complete(){
			if ( s.complete )
				s.complete(xhr, status);

			if ( s.global )
				jQuery.event.trigger( "ajaxComplete", [xhr, s] );

			if ( s.global && ! --jQuery.active )
				jQuery.event.trigger( "ajaxStop" );
		}

		return xhr;
	},

	handleError: function( s, xhr, status, e ) {
		if ( s.error ) s.error( xhr, status, e );

		if ( s.global )
			jQuery.event.trigger( "ajaxError", [xhr, s, e] );
	},

	active: 0,

	httpSuccess: function( xhr ) {
		try {
			return !xhr.status && location.protocol == "file:" ||
				( xhr.status >= 200 && xhr.status < 300 ) || xhr.status == 304 || xhr.status == 1223;
		} catch(e){}
		return false;
	},

	httpNotModified: function( xhr, url ) {
		try {
			var xhrRes = xhr.getResponseHeader("Last-Modified");

			return xhr.status == 304 || xhrRes == jQuery.lastModified[url];
		} catch(e){}
		return false;
	},

	httpData: function( xhr, type, s ) {
		var ct = xhr.getResponseHeader("content-type"),
			xml = type == "xml" || !type && ct && ct.indexOf("xml") >= 0,
			data = xml ? xhr.responseXML : xhr.responseText;

		if ( xml && data.documentElement.tagName == "parsererror" )
			throw "parsererror";

		if( s && s.dataFilter )
			data = s.dataFilter( data, type );

		if( typeof data === "string" ){

			if ( type == "script" )
				jQuery.globalEval( data );

			if ( type == "json" )
				data = window["eval"]("(" + data + ")");
		}

		return data;
	},

	param: function( a ) {
		var s = [ ];

		function add( key, value ){
			s[ s.length ] = encodeURIComponent(key) + '=' + encodeURIComponent(value);
		};

		if ( jQuery.isArray(a) || a.jquery )
			jQuery.each( a, function(){
				add( this.name, this.value );
			});

		else
			for ( var j in a )
				if ( jQuery.isArray(a[j]) )
					jQuery.each( a[j], function(){
						add( j, this );
					});
				else
					add( j, jQuery.isFunction(a[j]) ? a[j]() : a[j] );

		return s.join("&").replace(/%20/g, "+");
	}

});
var elemdisplay = {},
	timerId,
	fxAttrs = [
		[ "height", "marginTop", "marginBottom", "paddingTop", "paddingBottom" ],
		[ "width", "marginLeft", "marginRight", "paddingLeft", "paddingRight" ],
		[ "opacity" ]
	];

function genFx( type, num ){
	var obj = {};
	jQuery.each( fxAttrs.concat.apply([], fxAttrs.slice(0,num)), function(){
		obj[ this ] = type;
	});
	return obj;
}

jQuery.fn.extend({
	show: function(speed,callback){
		if ( speed ) {
			return this.animate( genFx("show", 3), speed, callback);
		} else {
			for ( var i = 0, l = this.length; i < l; i++ ){
				var old = jQuery.data(this[i], "olddisplay");

				this[i].style.display = old || "";

				if ( jQuery.css(this[i], "display") === "none" ) {
					var tagName = this[i].tagName, display;

					if ( elemdisplay[ tagName ] ) {
						display = elemdisplay[ tagName ];
					} else {
						var elem = jQuery("<" + tagName + " />").appendTo("body");

						display = elem.css("display");
						if ( display === "none" )
							display = "block";

						elem.remove();

						elemdisplay[ tagName ] = display;
					}

					jQuery.data(this[i], "olddisplay", display);
				}
			}

			for ( var i = 0, l = this.length; i < l; i++ ){
				this[i].style.display = jQuery.data(this[i], "olddisplay") || "";
			}

			return this;
		}
	},

	hide: function(speed,callback){
		if ( speed ) {
			return this.animate( genFx("hide", 3), speed, callback);
		} else {
			for ( var i = 0, l = this.length; i < l; i++ ){
				var old = jQuery.data(this[i], "olddisplay");
				if ( !old && old !== "none" )
					jQuery.data(this[i], "olddisplay", jQuery.css(this[i], "display"));
			}

			for ( var i = 0, l = this.length; i < l; i++ ){
				this[i].style.display = "none";
			}

			return this;
		}
	},

	_toggle: jQuery.fn.toggle,

	toggle: function( fn, fn2 ){
		var bool = typeof fn === "boolean";

		return jQuery.isFunction(fn) && jQuery.isFunction(fn2) ?
			this._toggle.apply( this, arguments ) :
			fn == null || bool ?
				this.each(function(){
					var state = bool ? fn : jQuery(this).is(":hidden");
					jQuery(this)[ state ? "show" : "hide" ]();
				}) :
				this.animate(genFx("toggle", 3), fn, fn2);
	},

	fadeTo: function(speed,to,callback){
		return this.animate({opacity: to}, speed, callback);
	},

	animate: function( prop, speed, easing, callback ) {
		var optall = jQuery.speed(speed, easing, callback);

		return this[ optall.queue === false ? "each" : "queue" ](function(){

			var opt = jQuery.extend({}, optall), p,
				hidden = this.nodeType == 1 && jQuery(this).is(":hidden"),
				self = this;

			for ( p in prop ) {
				if ( prop[p] == "hide" && hidden || prop[p] == "show" && !hidden )
					return opt.complete.call(this);

				if ( ( p == "height" || p == "width" ) && this.style ) {
					opt.display = jQuery.css(this, "display");

					opt.overflow = this.style.overflow;
				}
			}

			if ( opt.overflow != null )
				this.style.overflow = "hidden";

			opt.curAnim = jQuery.extend({}, prop);

			jQuery.each( prop, function(name, val){
				var e = new jQuery.fx( self, opt, name );

				if ( /toggle|show|hide/.test(val) )
					e[ val == "toggle" ? hidden ? "show" : "hide" : val ]( prop );
				else {
					var parts = val.toString().match(/^([+-]=)?([\d+-.]+)(.*)$/),
						start = e.cur(true) || 0;

					if ( parts ) {
						var end = parseFloat(parts[2]),
							unit = parts[3] || "px";

						if ( unit != "px" ) {
							self.style[ name ] = (end || 1) + unit;
							start = ((end || 1) / e.cur(true)) * start;
							self.style[ name ] = start + unit;
						}

						if ( parts[1] )
							end = ((parts[1] == "-=" ? -1 : 1) * end) + start;

						e.custom( start, end, unit );
					} else
						e.custom( start, val, "" );
				}
			});

			return true;
		});
	},

	stop: function(clearQueue, gotoEnd){
		var timers = jQuery.timers;

		if (clearQueue)
			this.queue([]);

		this.each(function(){
			for ( var i = timers.length - 1; i >= 0; i-- )
				if ( timers[i].elem == this ) {
					if (gotoEnd)
						timers[i](true);
					timers.splice(i, 1);
				}
		});

		if (!gotoEnd)
			this.dequeue();

		return this;
	}

});

jQuery.each({
	slideDown: genFx("show", 1),
	slideUp: genFx("hide", 1),
	slideToggle: genFx("toggle", 1),
	fadeIn: { opacity: "show" },
	fadeOut: { opacity: "hide" }
}, function( name, props ){
	jQuery.fn[ name ] = function( speed, callback ){
		return this.animate( props, speed, callback );
	};
});

jQuery.extend({

	speed: function(speed, easing, fn) {
		var opt = typeof speed === "object" ? speed : {
			complete: fn || !fn && easing ||
				jQuery.isFunction( speed ) && speed,
			duration: speed,
			easing: fn && easing || easing && !jQuery.isFunction(easing) && easing
		};

		opt.duration = jQuery.fx.off ? 0 : typeof opt.duration === "number" ? opt.duration :
			jQuery.fx.speeds[opt.duration] || jQuery.fx.speeds._default;

		opt.old = opt.complete;
		opt.complete = function(){
			if ( opt.queue !== false )
				jQuery(this).dequeue();
			if ( jQuery.isFunction( opt.old ) )
				opt.old.call( this );
		};

		return opt;
	},

	easing: {
		linear: function( p, n, firstNum, diff ) {
			return firstNum + diff * p;
		},
		swing: function( p, n, firstNum, diff ) {
			return ((-Math.cos(p*Math.PI)/2) + 0.5) * diff + firstNum;
		}
	},

	timers: [],

	fx: function( elem, options, prop ){
		this.options = options;
		this.elem = elem;
		this.prop = prop;

		if ( !options.orig )
			options.orig = {};
	}

});

jQuery.fx.prototype = {

	update: function(){
		if ( this.options.step )
			this.options.step.call( this.elem, this.now, this );

		(jQuery.fx.step[this.prop] || jQuery.fx.step._default)( this );

		if ( ( this.prop == "height" || this.prop == "width" ) && this.elem.style )
			this.elem.style.display = "block";
	},

	cur: function(force){
		if ( this.elem[this.prop] != null && (!this.elem.style || this.elem.style[this.prop] == null) )
			return this.elem[ this.prop ];

		var r = parseFloat(jQuery.css(this.elem, this.prop, force));
		return r && r > -10000 ? r : parseFloat(jQuery.curCSS(this.elem, this.prop)) || 0;
	},

	custom: function(from, to, unit){
		this.startTime = now();
		this.start = from;
		this.end = to;
		this.unit = unit || this.unit || "px";
		this.now = this.start;
		this.pos = this.state = 0;

		var self = this;
		function t(gotoEnd){
			return self.step(gotoEnd);
		}

		t.elem = this.elem;

		if ( t() && jQuery.timers.push(t) && !timerId ) {
			timerId = setInterval(function(){
				var timers = jQuery.timers;

				for ( var i = 0; i < timers.length; i++ )
					if ( !timers[i]() )
						timers.splice(i--, 1);

				if ( !timers.length ) {
					clearInterval( timerId );
					timerId = undefined;
				}
			}, 13);
		}
	},

	show: function(){
		this.options.orig[this.prop] = jQuery.attr( this.elem.style, this.prop );
		this.options.show = true;

		this.custom(this.prop == "width" || this.prop == "height" ? 1 : 0, this.cur());

		jQuery(this.elem).show();
	},

	hide: function(){
		this.options.orig[this.prop] = jQuery.attr( this.elem.style, this.prop );
		this.options.hide = true;

		this.custom(this.cur(), 0);
	},

	step: function(gotoEnd){
		var t = now();

		if ( gotoEnd || t >= this.options.duration + this.startTime ) {
			this.now = this.end;
			this.pos = this.state = 1;
			this.update();

			this.options.curAnim[ this.prop ] = true;

			var done = true;
			for ( var i in this.options.curAnim )
				if ( this.options.curAnim[i] !== true )
					done = false;

			if ( done ) {
				if ( this.options.display != null ) {
					this.elem.style.overflow = this.options.overflow;

					this.elem.style.display = this.options.display;
					if ( jQuery.css(this.elem, "display") == "none" )
						this.elem.style.display = "block";
				}

				if ( this.options.hide )
					jQuery(this.elem).hide();

				if ( this.options.hide || this.options.show )
					for ( var p in this.options.curAnim )
						jQuery.attr(this.elem.style, p, this.options.orig[p]);

				this.options.complete.call( this.elem );
			}

			return false;
		} else {
			var n = t - this.startTime;
			this.state = n / this.options.duration;

			this.pos = jQuery.easing[this.options.easing || (jQuery.easing.swing ? "swing" : "linear")](this.state, n, 0, 1, this.options.duration);
			this.now = this.start + ((this.end - this.start) * this.pos);

			this.update();
		}

		return true;
	}

};

jQuery.extend( jQuery.fx, {
	speeds:{
		slow: 600,
 		fast: 200,
 		_default: 400
	},
	step: {

		opacity: function(fx){
			jQuery.attr(fx.elem.style, "opacity", fx.now);
		},

		_default: function(fx){
			if ( fx.elem.style && fx.elem.style[ fx.prop ] != null )
				fx.elem.style[ fx.prop ] = fx.now + fx.unit;
			else
				fx.elem[ fx.prop ] = fx.now;
		}
	}
});
if ( document.documentElement["getBoundingClientRect"] )
	jQuery.fn.offset = function() {
		if ( !this[0] ) return { top: 0, left: 0 };
		if ( this[0] === this[0].ownerDocument.body ) return jQuery.offset.bodyOffset( this[0] );
		var box  = this[0].getBoundingClientRect(), doc = this[0].ownerDocument, body = doc.body, docElem = doc.documentElement,
			clientTop = docElem.clientTop || body.clientTop || 0, clientLeft = docElem.clientLeft || body.clientLeft || 0,
			top  = box.top  + (self.pageYOffset || jQuery.boxModel && docElem.scrollTop  || body.scrollTop ) - clientTop,
			left = box.left + (self.pageXOffset || jQuery.boxModel && docElem.scrollLeft || body.scrollLeft) - clientLeft;
		return { top: top, left: left };
	};
else
	jQuery.fn.offset = function() {
		if ( !this[0] ) return { top: 0, left: 0 };
		if ( this[0] === this[0].ownerDocument.body ) return jQuery.offset.bodyOffset( this[0] );
		jQuery.offset.initialized || jQuery.offset.initialize();

		var elem = this[0], offsetParent = elem.offsetParent, prevOffsetParent = elem,
			doc = elem.ownerDocument, computedStyle, docElem = doc.documentElement,
			body = doc.body, defaultView = doc.defaultView,
			prevComputedStyle = defaultView.getComputedStyle(elem, null),
			top = elem.offsetTop, left = elem.offsetLeft;

		while ( (elem = elem.parentNode) && elem !== body && elem !== docElem ) {
			computedStyle = defaultView.getComputedStyle(elem, null);
			top -= elem.scrollTop, left -= elem.scrollLeft;
			if ( elem === offsetParent ) {
				top += elem.offsetTop, left += elem.offsetLeft;
				if ( jQuery.offset.doesNotAddBorder && !(jQuery.offset.doesAddBorderForTableAndCells && /^t(able|d|h)$/i.test(elem.tagName)) )
					top  += parseInt( computedStyle.borderTopWidth,  10) || 0,
					left += parseInt( computedStyle.borderLeftWidth, 10) || 0;
				prevOffsetParent = offsetParent, offsetParent = elem.offsetParent;
			}
			if ( jQuery.offset.subtractsBorderForOverflowNotVisible && computedStyle.overflow !== "visible" )
				top  += parseInt( computedStyle.borderTopWidth,  10) || 0,
				left += parseInt( computedStyle.borderLeftWidth, 10) || 0;
			prevComputedStyle = computedStyle;
		}

		if ( prevComputedStyle.position === "relative" || prevComputedStyle.position === "static" )
			top  += body.offsetTop,
			left += body.offsetLeft;

		if ( prevComputedStyle.position === "fixed" )
			top  += Math.max(docElem.scrollTop, body.scrollTop),
			left += Math.max(docElem.scrollLeft, body.scrollLeft);

		return { top: top, left: left };
	};

jQuery.offset = {
	initialize: function() {
		if ( this.initialized ) return;
		var body = document.body, container = document.createElement('div'), innerDiv, checkDiv, table, td, rules, prop, bodyMarginTop = body.style.marginTop,
			html = '<div style="position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;"><div></div></div><table style="position:absolute;top:0;left:0;margin:0;border:5px solid #000;padding:0;width:1px;height:1px;" cellpadding="0" cellspacing="0"><tr><td></td></tr></table>';

		rules = { position: 'absolute', top: 0, left: 0, margin: 0, border: 0, width: '1px', height: '1px', visibility: 'hidden' };
		for ( prop in rules ) container.style[prop] = rules[prop];

		container.innerHTML = html;
		body.insertBefore(container, body.firstChild);
		innerDiv = container.firstChild, checkDiv = innerDiv.firstChild, td = innerDiv.nextSibling.firstChild.firstChild;

		this.doesNotAddBorder = (checkDiv.offsetTop !== 5);
		this.doesAddBorderForTableAndCells = (td.offsetTop === 5);

		innerDiv.style.overflow = 'hidden', innerDiv.style.position = 'relative';
		this.subtractsBorderForOverflowNotVisible = (checkDiv.offsetTop === -5);

		body.style.marginTop = '1px';
		this.doesNotIncludeMarginInBodyOffset = (body.offsetTop === 0);
		body.style.marginTop = bodyMarginTop;

		body.removeChild(container);
		this.initialized = true;
	},

	bodyOffset: function(body) {
		jQuery.offset.initialized || jQuery.offset.initialize();
		var top = body.offsetTop, left = body.offsetLeft;
		if ( jQuery.offset.doesNotIncludeMarginInBodyOffset )
			top  += parseInt( jQuery.curCSS(body, 'marginTop',  true), 10 ) || 0,
			left += parseInt( jQuery.curCSS(body, 'marginLeft', true), 10 ) || 0;
		return { top: top, left: left };
	}
};


jQuery.fn.extend({
	position: function() {
		var left = 0, top = 0, results;

		if ( this[0] ) {
			var offsetParent = this.offsetParent(),

			offset       = this.offset(),
			parentOffset = /^body|html$/i.test(offsetParent[0].tagName) ? { top: 0, left: 0 } : offsetParent.offset();

			offset.top  -= num( this, 'marginTop'  );
			offset.left -= num( this, 'marginLeft' );

			parentOffset.top  += num( offsetParent, 'borderTopWidth'  );
			parentOffset.left += num( offsetParent, 'borderLeftWidth' );

			results = {
				top:  offset.top  - parentOffset.top,
				left: offset.left - parentOffset.left
			};
		}

		return results;
	},

	offsetParent: function() {
		var offsetParent = this[0].offsetParent || document.body;
		while ( offsetParent && (!/^body|html$/i.test(offsetParent.tagName) && jQuery.css(offsetParent, 'position') == 'static') )
			offsetParent = offsetParent.offsetParent;
		return jQuery(offsetParent);
	}
});


jQuery.each( ['Left', 'Top'], function(i, name) {
	var method = 'scroll' + name;

	jQuery.fn[ method ] = function(val) {
		if (!this[0]) return null;

		return val !== undefined ?

			this.each(function() {
				this == window || this == document ?
					window.scrollTo(
						!i ? val : jQuery(window).scrollLeft(),
						 i ? val : jQuery(window).scrollTop()
					) :
					this[ method ] = val;
			}) :

			this[0] == window || this[0] == document ?
				self[ i ? 'pageYOffset' : 'pageXOffset' ] ||
					jQuery.boxModel && document.documentElement[ method ] ||
					document.body[ method ] :
				this[0][ method ];
	};
});
jQuery.each([ "Height", "Width" ], function(i, name){

	var tl = i ? "Left"  : "Top",  // top or left
		br = i ? "Right" : "Bottom", // bottom or right
		lower = name.toLowerCase();

	jQuery.fn["inner" + name] = function(){
		return this[0] ?
			jQuery.css( this[0], lower, false, "padding" ) :
			null;
	};

	jQuery.fn["outer" + name] = function(margin) {
		return this[0] ?
			jQuery.css( this[0], lower, false, margin ? "margin" : "border" ) :
			null;
	};

	var type = name.toLowerCase();

	jQuery.fn[ type ] = function( size ) {
		return this[0] == window ?
			document.compatMode == "CSS1Compat" && document.documentElement[ "client" + name ] ||
			document.body[ "client" + name ] :

			this[0] == document ?
				Math.max(
					document.documentElement["client" + name],
					document.body["scroll" + name], document.documentElement["scroll" + name],
					document.body["offset" + name], document.documentElement["offset" + name]
				) :

				size === undefined ?
					(this.length ? jQuery.css( this[0], type ) : null) :

					this.css( type, typeof size === "string" ? size : size + "px" );
	};

});
})();
/*
 * jQuery UI 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI
 */
;jQuery.ui || (function($) {

var _remove = $.fn.remove,
	isFF2 = $.browser.mozilla && (parseFloat($.browser.version) < 1.9);

$.ui = {
	version: "1.7.2",

	plugin: {
		add: function(module, option, set) {
			var proto = $.ui[module].prototype;
			for(var i in set) {
				proto.plugins[i] = proto.plugins[i] || [];
				proto.plugins[i].push([option, set[i]]);
			}
		},
		call: function(instance, name, args) {
			var set = instance.plugins[name];
			if(!set || !instance.element[0].parentNode) { return; }

			for (var i = 0; i < set.length; i++) {
				if (instance.options[set[i][0]]) {
					set[i][1].apply(instance.element, args);
				}
			}
		}
	},

	contains: function(a, b) {
		return document.compareDocumentPosition
			? a.compareDocumentPosition(b) & 16
			: a !== b && a.contains(b);
	},

	hasScroll: function(el, a) {

		if ($(el).css('overflow') == 'hidden') { return false; }

		var scroll = (a && a == 'left') ? 'scrollLeft' : 'scrollTop',
			has = false;

		if (el[scroll] > 0) { return true; }

		el[scroll] = 1;
		has = (el[scroll] > 0);
		el[scroll] = 0;
		return has;
	},

	isOverAxis: function(x, reference, size) {
		return (x > reference) && (x < (reference + size));
	},

	isOver: function(y, x, top, left, height, width) {
		return $.ui.isOverAxis(y, top, height) && $.ui.isOverAxis(x, left, width);
	},

	keyCode: {
		BACKSPACE: 8,
		CAPS_LOCK: 20,
		COMMA: 188,
		CONTROL: 17,
		DELETE: 46,
		DOWN: 40,
		END: 35,
		ENTER: 13,
		ESCAPE: 27,
		HOME: 36,
		INSERT: 45,
		LEFT: 37,
		NUMPAD_ADD: 107,
		NUMPAD_DECIMAL: 110,
		NUMPAD_DIVIDE: 111,
		NUMPAD_ENTER: 108,
		NUMPAD_MULTIPLY: 106,
		NUMPAD_SUBTRACT: 109,
		PAGE_DOWN: 34,
		PAGE_UP: 33,
		PERIOD: 190,
		RIGHT: 39,
		SHIFT: 16,
		SPACE: 32,
		TAB: 9,
		UP: 38
	}
};

if (isFF2) {
	var attr = $.attr,
		removeAttr = $.fn.removeAttr,
		ariaNS = "http://www.w3.org/2005/07/aaa",
		ariaState = /^aria-/,
		ariaRole = /^wairole:/;

	$.attr = function(elem, name, value) {
		var set = value !== undefined;

		return (name == 'role'
			? (set
				? attr.call(this, elem, name, "wairole:" + value)
				: (attr.apply(this, arguments) || "").replace(ariaRole, ""))
			: (ariaState.test(name)
				? (set
					? elem.setAttributeNS(ariaNS,
						name.replace(ariaState, "aaa:"), value)
					: attr.call(this, elem, name.replace(ariaState, "aaa:")))
				: attr.apply(this, arguments)));
	};

	$.fn.removeAttr = function(name) {
		return (ariaState.test(name)
			? this.each(function() {
				this.removeAttributeNS(ariaNS, name.replace(ariaState, ""));
			}) : removeAttr.call(this, name));
	};
}

$.fn.extend({
	remove: function() {
		$("*", this).add(this).each(function() {
			$(this).triggerHandler("remove");
		});
		return _remove.apply(this, arguments );
	},

	enableSelection: function() {
		return this
			.attr('unselectable', 'off')
			.css('MozUserSelect', '')
			.unbind('selectstart.ui');
	},

	disableSelection: function() {
		return this
			.attr('unselectable', 'on')
			.css('MozUserSelect', 'none')
			.bind('selectstart.ui', function() { return false; });
	},

	scrollParent: function() {
		var scrollParent;
		if(($.browser.msie && (/(static|relative)/).test(this.css('position'))) || (/absolute/).test(this.css('position'))) {
			scrollParent = this.parents().filter(function() {
				return (/(relative|absolute|fixed)/).test($.curCSS(this,'position',1)) && (/(auto|scroll)/).test($.curCSS(this,'overflow',1)+$.curCSS(this,'overflow-y',1)+$.curCSS(this,'overflow-x',1));
			}).eq(0);
		} else {
			scrollParent = this.parents().filter(function() {
				return (/(auto|scroll)/).test($.curCSS(this,'overflow',1)+$.curCSS(this,'overflow-y',1)+$.curCSS(this,'overflow-x',1));
			}).eq(0);
		}

		return (/fixed/).test(this.css('position')) || !scrollParent.length ? $(document) : scrollParent;
	}
});


$.extend($.expr[':'], {
	data: function(elem, i, match) {
		return !!$.data(elem, match[3]);
	},

	focusable: function(element) {
		var nodeName = element.nodeName.toLowerCase(),
			tabIndex = $.attr(element, 'tabindex');
		return (/input|select|textarea|button|object/.test(nodeName)
			? !element.disabled
			: 'a' == nodeName || 'area' == nodeName
				? element.href || !isNaN(tabIndex)
				: !isNaN(tabIndex))
			&& !$(element)['area' == nodeName ? 'parents' : 'closest'](':hidden').length;
	},

	tabbable: function(element) {
		var tabIndex = $.attr(element, 'tabindex');
		return (isNaN(tabIndex) || tabIndex >= 0) && $(element).is(':focusable');
	}
});


function getter(namespace, plugin, method, args) {
	function getMethods(type) {
		var methods = $[namespace][plugin][type] || [];
		return (typeof methods == 'string' ? methods.split(/,?\s+/) : methods);
	}

	var methods = getMethods('getter');
	if (args.length == 1 && typeof args[0] == 'string') {
		methods = methods.concat(getMethods('getterSetter'));
	}
	return ($.inArray(method, methods) != -1);
}

$.widget = function(name, prototype) {
	var namespace = name.split(".")[0];
	name = name.split(".")[1];

	$.fn[name] = function(options) {
		var isMethodCall = (typeof options == 'string'),
			args = Array.prototype.slice.call(arguments, 1);

		if (isMethodCall && options.substring(0, 1) == '_') {
			return this;
		}

		if (isMethodCall && getter(namespace, name, options, args)) {
			var instance = $.data(this[0], name);
			return (instance ? instance[options].apply(instance, args)
				: undefined);
		}

		return this.each(function() {
			var instance = $.data(this, name);

			(!instance && !isMethodCall &&
				$.data(this, name, new $[namespace][name](this, options))._init());

			(instance && isMethodCall && $.isFunction(instance[options]) &&
				instance[options].apply(instance, args));
		});
	};

	$[namespace] = $[namespace] || {};
	$[namespace][name] = function(element, options) {
		var self = this;

		this.namespace = namespace;
		this.widgetName = name;
		this.widgetEventPrefix = $[namespace][name].eventPrefix || name;
		this.widgetBaseClass = namespace + '-' + name;

		this.options = $.extend({},
			$.widget.defaults,
			$[namespace][name].defaults,
			$.metadata && $.metadata.get(element)[name],
			options);

		this.element = $(element)
			.bind('setData.' + name, function(event, key, value) {
				if (event.target == element) {
					return self._setData(key, value);
				}
			})
			.bind('getData.' + name, function(event, key) {
				if (event.target == element) {
					return self._getData(key);
				}
			})
			.bind('remove', function() {
				return self.destroy();
			});
	};

	$[namespace][name].prototype = $.extend({}, $.widget.prototype, prototype);

	$[namespace][name].getterSetter = 'option';
};

$.widget.prototype = {
	_init: function() {},
	destroy: function() {
		this.element.removeData(this.widgetName)
			.removeClass(this.widgetBaseClass + '-disabled' + ' ' + this.namespace + '-state-disabled')
			.removeAttr('aria-disabled');
	},

	option: function(key, value) {
		var options = key,
			self = this;

		if (typeof key == "string") {
			if (value === undefined) {
				return this._getData(key);
			}
			options = {};
			options[key] = value;
		}

		$.each(options, function(key, value) {
			self._setData(key, value);
		});
	},
	_getData: function(key) {
		return this.options[key];
	},
	_setData: function(key, value) {
		this.options[key] = value;

		if (key == 'disabled') {
			this.element
				[value ? 'addClass' : 'removeClass'](
					this.widgetBaseClass + '-disabled' + ' ' +
					this.namespace + '-state-disabled')
				.attr("aria-disabled", value);
		}
	},

	enable: function() {
		this._setData('disabled', false);
	},
	disable: function() {
		this._setData('disabled', true);
	},

	_trigger: function(type, event, data) {
		var callback = this.options[type],
			eventName = (type == this.widgetEventPrefix
				? type : this.widgetEventPrefix + type);

		event = $.Event(event);
		event.type = eventName;

		if (event.originalEvent) {
			for (var i = $.event.props.length, prop; i;) {
				prop = $.event.props[--i];
				event[prop] = event.originalEvent[prop];
			}
		}

		this.element.trigger(event, data);

		return !($.isFunction(callback) && callback.call(this.element[0], event, data) === false
			|| event.isDefaultPrevented());
	}
};

$.widget.defaults = {
	disabled: false
};



$.ui.mouse = {
	_mouseInit: function() {
		var self = this;

		this.element
			.bind('mousedown.'+this.widgetName, function(event) {
				return self._mouseDown(event);
			})
			.bind('click.'+this.widgetName, function(event) {
				if(self._preventClickEvent) {
					self._preventClickEvent = false;
					event.stopImmediatePropagation();
					return false;
				}
			});

		if ($.browser.msie) {
			this._mouseUnselectable = this.element.attr('unselectable');
			this.element.attr('unselectable', 'on');
		}

		this.started = false;
	},

	_mouseDestroy: function() {
		this.element.unbind('.'+this.widgetName);

		($.browser.msie
			&& this.element.attr('unselectable', this._mouseUnselectable));
	},

	_mouseDown: function(event) {
		event.originalEvent = event.originalEvent || {};
		if (event.originalEvent.mouseHandled) { return; }

		(this._mouseStarted && this._mouseUp(event));

		this._mouseDownEvent = event;

		var self = this,
			btnIsLeft = (event.which == 1),
			elIsCancel = (typeof this.options.cancel == "string" ? $(event.target).parents().add(event.target).filter(this.options.cancel).length : false);
		if (!btnIsLeft || elIsCancel || !this._mouseCapture(event)) {
			return true;
		}

		this.mouseDelayMet = !this.options.delay;
		if (!this.mouseDelayMet) {
			this._mouseDelayTimer = setTimeout(function() {
				self.mouseDelayMet = true;
			}, this.options.delay);
		}

		if (this._mouseDistanceMet(event) && this._mouseDelayMet(event)) {
			this._mouseStarted = (this._mouseStart(event) !== false);
			if (!this._mouseStarted) {
				event.preventDefault();
				return true;
			}
		}

		this._mouseMoveDelegate = function(event) {
			return self._mouseMove(event);
		};
		this._mouseUpDelegate = function(event) {
			return self._mouseUp(event);
		};
		$(document)
			.bind('mousemove.'+this.widgetName, this._mouseMoveDelegate)
			.bind('mouseup.'+this.widgetName, this._mouseUpDelegate);

		($.browser.safari || event.preventDefault());

		event.originalEvent.mouseHandled = true;
		return true;
	},

	_mouseMove: function(event) {
		if ($.browser.msie && !event.button) {
			return this._mouseUp(event);
		}

		if (this._mouseStarted) {
			this._mouseDrag(event);
			return event.preventDefault();
		}

		if (this._mouseDistanceMet(event) && this._mouseDelayMet(event)) {
			this._mouseStarted =
				(this._mouseStart(this._mouseDownEvent, event) !== false);
			(this._mouseStarted ? this._mouseDrag(event) : this._mouseUp(event));
		}

		return !this._mouseStarted;
	},

	_mouseUp: function(event) {
		$(document)
			.unbind('mousemove.'+this.widgetName, this._mouseMoveDelegate)
			.unbind('mouseup.'+this.widgetName, this._mouseUpDelegate);

		if (this._mouseStarted) {
			this._mouseStarted = false;
			this._preventClickEvent = (event.target == this._mouseDownEvent.target);
			this._mouseStop(event);
		}

		return false;
	},

	_mouseDistanceMet: function(event) {
		return (Math.max(
				Math.abs(this._mouseDownEvent.pageX - event.pageX),
				Math.abs(this._mouseDownEvent.pageY - event.pageY)
			) >= this.options.distance
		);
	},

	_mouseDelayMet: function(event) {
		return this.mouseDelayMet;
	},

	_mouseStart: function(event) {},
	_mouseDrag: function(event) {},
	_mouseStop: function(event) {},
	_mouseCapture: function(event) { return true; }
};

$.ui.mouse.defaults = {
	cancel: null,
	distance: 1,
	delay: 0
};

})(jQuery);
/*
 * jQuery UI Draggable 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Draggables
 *
 * Depends:
 *	ui.core.js
 */
(function($) {

$.widget("ui.draggable", $.extend({}, $.ui.mouse, {

	_init: function() {

		if (this.options.helper == 'original' && !(/^(?:r|a|f)/).test(this.element.css("position")))
			this.element[0].style.position = 'relative';

		(this.options.addClasses && this.element.addClass("ui-draggable"));
		(this.options.disabled && this.element.addClass("ui-draggable-disabled"));

		this._mouseInit();

	},

	destroy: function() {
		if(!this.element.data('draggable')) return;
		this.element
			.removeData("draggable")
			.unbind(".draggable")
			.removeClass("ui-draggable"
				+ " ui-draggable-dragging"
				+ " ui-draggable-disabled");
		this._mouseDestroy();
	},

	_mouseCapture: function(event) {

		var o = this.options;

		if (this.helper || o.disabled || $(event.target).is('.ui-resizable-handle'))
			return false;

		this.handle = this._getHandle(event);
		if (!this.handle)
			return false;

		return true;

	},

	_mouseStart: function(event) {

		var o = this.options;

		this.helper = this._createHelper(event);

		this._cacheHelperProportions();

		if($.ui.ddmanager)
			$.ui.ddmanager.current = this;

		/*
		 * - Position generation -
		 * This block generates everything position related - it's the core of draggables.
		 */

		this._cacheMargins();

		this.cssPosition = this.helper.css("position");
		this.scrollParent = this.helper.scrollParent();

		this.offset = this.element.offset();
		this.offset = {
			top: this.offset.top - this.margins.top,
			left: this.offset.left - this.margins.left
		};

		$.extend(this.offset, {
			click: { //Where the click happened, relative to the element
				left: event.pageX - this.offset.left,
				top: event.pageY - this.offset.top
			},
			parent: this._getParentOffset(),
			relative: this._getRelativeOffset() //This is a relative to absolute position minus the actual position calculation - only used for relative positioned helper
		});

		this.originalPosition = this._generatePosition(event);
		this.originalPageX = event.pageX;
		this.originalPageY = event.pageY;

		if(o.cursorAt)
			this._adjustOffsetFromHelper(o.cursorAt);

		if(o.containment)
			this._setContainment();

		this._trigger("start", event);

		this._cacheHelperProportions();

		if ($.ui.ddmanager && !o.dropBehaviour)
			$.ui.ddmanager.prepareOffsets(this, event);

		this.helper.addClass("ui-draggable-dragging");
		this._mouseDrag(event, true); //Execute the drag once - this causes the helper not to be visible before getting its correct position
		return true;
	},

	_mouseDrag: function(event, noPropagation) {

		this.position = this._generatePosition(event);
		this.positionAbs = this._convertPositionTo("absolute");

		if (!noPropagation) {
			var ui = this._uiHash();
			this._trigger('drag', event, ui);
			this.position = ui.position;
		}

		if(!this.options.axis || this.options.axis != "y") this.helper[0].style.left = this.position.left+'px';
		if(!this.options.axis || this.options.axis != "x") this.helper[0].style.top = this.position.top+'px';

		if($.ui.ddmanager) $.ui.ddmanager.drag(this, event);

		return false;
	},

	_mouseStop: function(event) {

		var dropped = false;
		if ($.ui.ddmanager && !this.options.dropBehaviour)
			dropped = $.ui.ddmanager.drop(this, event);

		if(this.dropped) {
			dropped = this.dropped;
			this.dropped = false;
		}

		if((this.options.revert == "invalid" && !dropped) || (this.options.revert == "valid" && dropped) || this.options.revert === true || ($.isFunction(this.options.revert) && this.options.revert.call(this.element, dropped))) {
			var self = this;
			$(this.helper).animate(this.originalPosition, parseInt(this.options.revertDuration, 10), function() {
				self._trigger("stop", event);
				self._clear();
			});
		} else {
			this._trigger("stop", event);
			this._clear();
		}

		return false;
	},

	_getHandle: function(event) {

		var handle = !this.options.handle || !$(this.options.handle, this.element).length ? true : false;
		$(this.options.handle, this.element)
			.find("*")
			.andSelf()
			.each(function() {
				if(this == event.target) handle = true;
			});

		return handle;

	},

	_createHelper: function(event) {

		var o = this.options;
		var helper = $.isFunction(o.helper) ? $(o.helper.apply(this.element[0], [event])) : (o.helper == 'clone' ? this.element.clone() : this.element);

		if(!helper.parents('body').length)
			helper.appendTo((o.appendTo == 'parent' ? this.element[0].parentNode : o.appendTo));

		if(helper[0] != this.element[0] && !(/(fixed|absolute)/).test(helper.css("position")))
			helper.css("position", "absolute");

		return helper;

	},

	_adjustOffsetFromHelper: function(obj) {
		if(obj.left != undefined) this.offset.click.left = obj.left + this.margins.left;
		if(obj.right != undefined) this.offset.click.left = this.helperProportions.width - obj.right + this.margins.left;
		if(obj.top != undefined) this.offset.click.top = obj.top + this.margins.top;
		if(obj.bottom != undefined) this.offset.click.top = this.helperProportions.height - obj.bottom + this.margins.top;
	},

	_getParentOffset: function() {

		this.offsetParent = this.helper.offsetParent();
		var po = this.offsetParent.offset();

		if(this.cssPosition == 'absolute' && this.scrollParent[0] != document && $.ui.contains(this.scrollParent[0], this.offsetParent[0])) {
			po.left += this.scrollParent.scrollLeft();
			po.top += this.scrollParent.scrollTop();
		}

		if((this.offsetParent[0] == document.body) //This needs to be actually done for all browsers, since pageX/pageY includes this information
		|| (this.offsetParent[0].tagName && this.offsetParent[0].tagName.toLowerCase() == 'html' && $.browser.msie)) //Ugly IE fix
			po = { top: 0, left: 0 };

		return {
			top: po.top + (parseInt(this.offsetParent.css("borderTopWidth"),10) || 0),
			left: po.left + (parseInt(this.offsetParent.css("borderLeftWidth"),10) || 0)
		};

	},

	_getRelativeOffset: function() {

		if(this.cssPosition == "relative") {
			var p = this.element.position();
			return {
				top: p.top - (parseInt(this.helper.css("top"),10) || 0) + this.scrollParent.scrollTop(),
				left: p.left - (parseInt(this.helper.css("left"),10) || 0) + this.scrollParent.scrollLeft()
			};
		} else {
			return { top: 0, left: 0 };
		}

	},

	_cacheMargins: function() {
		this.margins = {
			left: (parseInt(this.element.css("marginLeft"),10) || 0),
			top: (parseInt(this.element.css("marginTop"),10) || 0)
		};
	},

	_cacheHelperProportions: function() {
		this.helperProportions = {
			width: this.helper.outerWidth(),
			height: this.helper.outerHeight()
		};
	},

	_setContainment: function() {

		var o = this.options;
		if(o.containment == 'parent') o.containment = this.helper[0].parentNode;
		if(o.containment == 'document' || o.containment == 'window') this.containment = [
			0 - this.offset.relative.left - this.offset.parent.left,
			0 - this.offset.relative.top - this.offset.parent.top,
			$(o.containment == 'document' ? document : window).width() - this.helperProportions.width - this.margins.left,
			($(o.containment == 'document' ? document : window).height() || document.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top
		];

		if(!(/^(document|window|parent)$/).test(o.containment) && o.containment.constructor != Array) {
			var ce = $(o.containment)[0]; if(!ce) return;
			var co = $(o.containment).offset();
			var over = ($(ce).css("overflow") != 'hidden');

			this.containment = [
				co.left + (parseInt($(ce).css("borderLeftWidth"),10) || 0) + (parseInt($(ce).css("paddingLeft"),10) || 0) - this.margins.left,
				co.top + (parseInt($(ce).css("borderTopWidth"),10) || 0) + (parseInt($(ce).css("paddingTop"),10) || 0) - this.margins.top,
				co.left+(over ? Math.max(ce.scrollWidth,ce.offsetWidth) : ce.offsetWidth) - (parseInt($(ce).css("borderLeftWidth"),10) || 0) - (parseInt($(ce).css("paddingRight"),10) || 0) - this.helperProportions.width - this.margins.left,
				co.top+(over ? Math.max(ce.scrollHeight,ce.offsetHeight) : ce.offsetHeight) - (parseInt($(ce).css("borderTopWidth"),10) || 0) - (parseInt($(ce).css("paddingBottom"),10) || 0) - this.helperProportions.height - this.margins.top
			];

		} else if(o.containment.constructor == Array) {
			this.containment = o.containment;
		}

	},

	_convertPositionTo: function(d, pos) {

		if(!pos) pos = this.position;
		var mod = d == "absolute" ? 1 : -1;
		var o = this.options, scroll = this.cssPosition == 'absolute' && !(this.scrollParent[0] != document && $.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = (/(html|body)/i).test(scroll[0].tagName);

		return {
			top: (
				pos.top																	// The absolute mouse position
				+ this.offset.relative.top * mod										// Only for relative positioned nodes: Relative offset from element to offset parent
				+ this.offset.parent.top * mod											// The offsetParent's offset without borders (offset + border)
				- ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollTop() : ( scrollIsRootNode ? 0 : scroll.scrollTop() ) ) * mod)
			),
			left: (
				pos.left																// The absolute mouse position
				+ this.offset.relative.left * mod										// Only for relative positioned nodes: Relative offset from element to offset parent
				+ this.offset.parent.left * mod											// The offsetParent's offset without borders (offset + border)
				- ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft() ) * mod)
			)
		};

	},

	_generatePosition: function(event) {

		var o = this.options, scroll = this.cssPosition == 'absolute' && !(this.scrollParent[0] != document && $.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = (/(html|body)/i).test(scroll[0].tagName);

		if(this.cssPosition == 'relative' && !(this.scrollParent[0] != document && this.scrollParent[0] != this.offsetParent[0])) {
			this.offset.relative = this._getRelativeOffset();
		}

		var pageX = event.pageX;
		var pageY = event.pageY;

		/*
		 * - Position constraining -
		 * Constrain the position to a mix of grid, containment.
		 */

		if(this.originalPosition) { //If we are not dragging yet, we won't check for options

			if(this.containment) {
				if(event.pageX - this.offset.click.left < this.containment[0]) pageX = this.containment[0] + this.offset.click.left;
				if(event.pageY - this.offset.click.top < this.containment[1]) pageY = this.containment[1] + this.offset.click.top;
				if(event.pageX - this.offset.click.left > this.containment[2]) pageX = this.containment[2] + this.offset.click.left;
				if(event.pageY - this.offset.click.top > this.containment[3]) pageY = this.containment[3] + this.offset.click.top;
			}

			if(o.grid) {
				var top = this.originalPageY + Math.round((pageY - this.originalPageY) / o.grid[1]) * o.grid[1];
				pageY = this.containment ? (!(top - this.offset.click.top < this.containment[1] || top - this.offset.click.top > this.containment[3]) ? top : (!(top - this.offset.click.top < this.containment[1]) ? top - o.grid[1] : top + o.grid[1])) : top;

				var left = this.originalPageX + Math.round((pageX - this.originalPageX) / o.grid[0]) * o.grid[0];
				pageX = this.containment ? (!(left - this.offset.click.left < this.containment[0] || left - this.offset.click.left > this.containment[2]) ? left : (!(left - this.offset.click.left < this.containment[0]) ? left - o.grid[0] : left + o.grid[0])) : left;
			}

		}

		return {
			top: (
				pageY																// The absolute mouse position
				- this.offset.click.top													// Click offset (relative to the element)
				- this.offset.relative.top												// Only for relative positioned nodes: Relative offset from element to offset parent
				- this.offset.parent.top												// The offsetParent's offset without borders (offset + border)
				+ ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollTop() : ( scrollIsRootNode ? 0 : scroll.scrollTop() ) ))
			),
			left: (
				pageX																// The absolute mouse position
				- this.offset.click.left												// Click offset (relative to the element)
				- this.offset.relative.left												// Only for relative positioned nodes: Relative offset from element to offset parent
				- this.offset.parent.left												// The offsetParent's offset without borders (offset + border)
				+ ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft() ))
			)
		};

	},

	_clear: function() {
		this.helper.removeClass("ui-draggable-dragging");
		if(this.helper[0] != this.element[0] && !this.cancelHelperRemoval) this.helper.remove();
		this.helper = null;
		this.cancelHelperRemoval = false;
	},


	_trigger: function(type, event, ui) {
		ui = ui || this._uiHash();
		$.ui.plugin.call(this, type, [event, ui]);
		if(type == "drag") this.positionAbs = this._convertPositionTo("absolute"); //The absolute position has to be recalculated after plugins
		return $.widget.prototype._trigger.call(this, type, event, ui);
	},

	plugins: {},

	_uiHash: function(event) {
		return {
			helper: this.helper,
			position: this.position,
			absolutePosition: this.positionAbs, //deprecated
			offset: this.positionAbs
		};
	}

}));

$.extend($.ui.draggable, {
	version: "1.7.2",
	eventPrefix: "drag",
	defaults: {
		addClasses: true,
		appendTo: "parent",
		axis: false,
		cancel: ":input,option",
		connectToSortable: false,
		containment: false,
		cursor: "auto",
		cursorAt: false,
		delay: 0,
		distance: 1,
		grid: false,
		handle: false,
		helper: "original",
		iframeFix: false,
		opacity: false,
		refreshPositions: false,
		revert: false,
		revertDuration: 500,
		scope: "default",
		scroll: true,
		scrollSensitivity: 20,
		scrollSpeed: 20,
		snap: false,
		snapMode: "both",
		snapTolerance: 20,
		stack: false,
		zIndex: false
	}
});

$.ui.plugin.add("draggable", "connectToSortable", {
	start: function(event, ui) {

		var inst = $(this).data("draggable"), o = inst.options,
			uiSortable = $.extend({}, ui, { item: inst.element });
		inst.sortables = [];
		$(o.connectToSortable).each(function() {
			var sortable = $.data(this, 'sortable');
			if (sortable && !sortable.options.disabled) {
				inst.sortables.push({
					instance: sortable,
					shouldRevert: sortable.options.revert
				});
				sortable._refreshItems();	//Do a one-time refresh at start to refresh the containerCache
				sortable._trigger("activate", event, uiSortable);
			}
		});

	},
	stop: function(event, ui) {

		var inst = $(this).data("draggable"),
			uiSortable = $.extend({}, ui, { item: inst.element });

		$.each(inst.sortables, function() {
			if(this.instance.isOver) {

				this.instance.isOver = 0;

				inst.cancelHelperRemoval = true; //Don't remove the helper in the draggable instance
				this.instance.cancelHelperRemoval = false; //Remove it in the sortable instance (so sortable plugins like revert still work)

				if(this.shouldRevert) this.instance.options.revert = true;

				this.instance._mouseStop(event);

				this.instance.options.helper = this.instance.options._helper;

				if(inst.options.helper == 'original')
					this.instance.currentItem.css({ top: 'auto', left: 'auto' });

			} else {
				this.instance.cancelHelperRemoval = false; //Remove the helper in the sortable instance
				this.instance._trigger("deactivate", event, uiSortable);
			}

		});

	},
	drag: function(event, ui) {

		var inst = $(this).data("draggable"), self = this;

		var checkPos = function(o) {
			var dyClick = this.offset.click.top, dxClick = this.offset.click.left;
			var helperTop = this.positionAbs.top, helperLeft = this.positionAbs.left;
			var itemHeight = o.height, itemWidth = o.width;
			var itemTop = o.top, itemLeft = o.left;

			return $.ui.isOver(helperTop + dyClick, helperLeft + dxClick, itemTop, itemLeft, itemHeight, itemWidth);
		};

		$.each(inst.sortables, function(i) {

			this.instance.positionAbs = inst.positionAbs;
			this.instance.helperProportions = inst.helperProportions;
			this.instance.offset.click = inst.offset.click;

			if(this.instance._intersectsWith(this.instance.containerCache)) {

				if(!this.instance.isOver) {

					this.instance.isOver = 1;
					this.instance.currentItem = $(self).clone().appendTo(this.instance.element).data("sortable-item", true);
					this.instance.options._helper = this.instance.options.helper; //Store helper option to later restore it
					this.instance.options.helper = function() { return ui.helper[0]; };

					event.target = this.instance.currentItem[0];
					this.instance._mouseCapture(event, true);
					this.instance._mouseStart(event, true, true);

					this.instance.offset.click.top = inst.offset.click.top;
					this.instance.offset.click.left = inst.offset.click.left;
					this.instance.offset.parent.left -= inst.offset.parent.left - this.instance.offset.parent.left;
					this.instance.offset.parent.top -= inst.offset.parent.top - this.instance.offset.parent.top;

					inst._trigger("toSortable", event);
					inst.dropped = this.instance.element; //draggable revert needs that
					inst.currentItem = inst.element;
					this.instance.fromOutside = inst;

				}

				if(this.instance.currentItem) this.instance._mouseDrag(event);

			} else {

				if(this.instance.isOver) {

					this.instance.isOver = 0;
					this.instance.cancelHelperRemoval = true;

					this.instance.options.revert = false;

					this.instance._trigger('out', event, this.instance._uiHash(this.instance));

					this.instance._mouseStop(event, true);
					this.instance.options.helper = this.instance.options._helper;

					this.instance.currentItem.remove();
					if(this.instance.placeholder) this.instance.placeholder.remove();

					inst._trigger("fromSortable", event);
					inst.dropped = false; //draggable revert needs that
				}

			};

		});

	}
});

$.ui.plugin.add("draggable", "cursor", {
	start: function(event, ui) {
		var t = $('body'), o = $(this).data('draggable').options;
		if (t.css("cursor")) o._cursor = t.css("cursor");
		t.css("cursor", o.cursor);
	},
	stop: function(event, ui) {
		var o = $(this).data('draggable').options;
		if (o._cursor) $('body').css("cursor", o._cursor);
	}
});

$.ui.plugin.add("draggable", "iframeFix", {
	start: function(event, ui) {
		var o = $(this).data('draggable').options;
		$(o.iframeFix === true ? "iframe" : o.iframeFix).each(function() {
			$('<div class="ui-draggable-iframeFix" style="background: #fff;"></div>')
			.css({
				width: this.offsetWidth+"px", height: this.offsetHeight+"px",
				position: "absolute", opacity: "0.001", zIndex: 1000
			})
			.css($(this).offset())
			.appendTo("body");
		});
	},
	stop: function(event, ui) {
		$("div.ui-draggable-iframeFix").each(function() { this.parentNode.removeChild(this); }); //Remove frame helpers
	}
});

$.ui.plugin.add("draggable", "opacity", {
	start: function(event, ui) {
		var t = $(ui.helper), o = $(this).data('draggable').options;
		if(t.css("opacity")) o._opacity = t.css("opacity");
		t.css('opacity', o.opacity);
	},
	stop: function(event, ui) {
		var o = $(this).data('draggable').options;
		if(o._opacity) $(ui.helper).css('opacity', o._opacity);
	}
});

$.ui.plugin.add("draggable", "scroll", {
	start: function(event, ui) {
		var i = $(this).data("draggable");
		if(i.scrollParent[0] != document && i.scrollParent[0].tagName != 'HTML') i.overflowOffset = i.scrollParent.offset();
	},
	drag: function(event, ui) {

		var i = $(this).data("draggable"), o = i.options, scrolled = false;

		if(i.scrollParent[0] != document && i.scrollParent[0].tagName != 'HTML') {

			if(!o.axis || o.axis != 'x') {
				if((i.overflowOffset.top + i.scrollParent[0].offsetHeight) - event.pageY < o.scrollSensitivity)
					i.scrollParent[0].scrollTop = scrolled = i.scrollParent[0].scrollTop + o.scrollSpeed;
				else if(event.pageY - i.overflowOffset.top < o.scrollSensitivity)
					i.scrollParent[0].scrollTop = scrolled = i.scrollParent[0].scrollTop - o.scrollSpeed;
			}

			if(!o.axis || o.axis != 'y') {
				if((i.overflowOffset.left + i.scrollParent[0].offsetWidth) - event.pageX < o.scrollSensitivity)
					i.scrollParent[0].scrollLeft = scrolled = i.scrollParent[0].scrollLeft + o.scrollSpeed;
				else if(event.pageX - i.overflowOffset.left < o.scrollSensitivity)
					i.scrollParent[0].scrollLeft = scrolled = i.scrollParent[0].scrollLeft - o.scrollSpeed;
			}

		} else {

			if(!o.axis || o.axis != 'x') {
				if(event.pageY - $(document).scrollTop() < o.scrollSensitivity)
					scrolled = $(document).scrollTop($(document).scrollTop() - o.scrollSpeed);
				else if($(window).height() - (event.pageY - $(document).scrollTop()) < o.scrollSensitivity)
					scrolled = $(document).scrollTop($(document).scrollTop() + o.scrollSpeed);
			}

			if(!o.axis || o.axis != 'y') {
				if(event.pageX - $(document).scrollLeft() < o.scrollSensitivity)
					scrolled = $(document).scrollLeft($(document).scrollLeft() - o.scrollSpeed);
				else if($(window).width() - (event.pageX - $(document).scrollLeft()) < o.scrollSensitivity)
					scrolled = $(document).scrollLeft($(document).scrollLeft() + o.scrollSpeed);
			}

		}

		if(scrolled !== false && $.ui.ddmanager && !o.dropBehaviour)
			$.ui.ddmanager.prepareOffsets(i, event);

	}
});

$.ui.plugin.add("draggable", "snap", {
	start: function(event, ui) {

		var i = $(this).data("draggable"), o = i.options;
		i.snapElements = [];

		$(o.snap.constructor != String ? ( o.snap.items || ':data(draggable)' ) : o.snap).each(function() {
			var $t = $(this); var $o = $t.offset();
			if(this != i.element[0]) i.snapElements.push({
				item: this,
				width: $t.outerWidth(), height: $t.outerHeight(),
				top: $o.top, left: $o.left
			});
		});

	},
	drag: function(event, ui) {

		var inst = $(this).data("draggable"), o = inst.options;
		var d = o.snapTolerance;

		var x1 = ui.offset.left, x2 = x1 + inst.helperProportions.width,
			y1 = ui.offset.top, y2 = y1 + inst.helperProportions.height;

		for (var i = inst.snapElements.length - 1; i >= 0; i--){

			var l = inst.snapElements[i].left, r = l + inst.snapElements[i].width,
				t = inst.snapElements[i].top, b = t + inst.snapElements[i].height;

			if(!((l-d < x1 && x1 < r+d && t-d < y1 && y1 < b+d) || (l-d < x1 && x1 < r+d && t-d < y2 && y2 < b+d) || (l-d < x2 && x2 < r+d && t-d < y1 && y1 < b+d) || (l-d < x2 && x2 < r+d && t-d < y2 && y2 < b+d))) {
				if(inst.snapElements[i].snapping) (inst.options.snap.release && inst.options.snap.release.call(inst.element, event, $.extend(inst._uiHash(), { snapItem: inst.snapElements[i].item })));
				inst.snapElements[i].snapping = false;
				continue;
			}

			if(o.snapMode != 'inner') {
				var ts = Math.abs(t - y2) <= d;
				var bs = Math.abs(b - y1) <= d;
				var ls = Math.abs(l - x2) <= d;
				var rs = Math.abs(r - x1) <= d;
				if(ts) ui.position.top = inst._convertPositionTo("relative", { top: t - inst.helperProportions.height, left: 0 }).top - inst.margins.top;
				if(bs) ui.position.top = inst._convertPositionTo("relative", { top: b, left: 0 }).top - inst.margins.top;
				if(ls) ui.position.left = inst._convertPositionTo("relative", { top: 0, left: l - inst.helperProportions.width }).left - inst.margins.left;
				if(rs) ui.position.left = inst._convertPositionTo("relative", { top: 0, left: r }).left - inst.margins.left;
			}

			var first = (ts || bs || ls || rs);

			if(o.snapMode != 'outer') {
				var ts = Math.abs(t - y1) <= d;
				var bs = Math.abs(b - y2) <= d;
				var ls = Math.abs(l - x1) <= d;
				var rs = Math.abs(r - x2) <= d;
				if(ts) ui.position.top = inst._convertPositionTo("relative", { top: t, left: 0 }).top - inst.margins.top;
				if(bs) ui.position.top = inst._convertPositionTo("relative", { top: b - inst.helperProportions.height, left: 0 }).top - inst.margins.top;
				if(ls) ui.position.left = inst._convertPositionTo("relative", { top: 0, left: l }).left - inst.margins.left;
				if(rs) ui.position.left = inst._convertPositionTo("relative", { top: 0, left: r - inst.helperProportions.width }).left - inst.margins.left;
			}

			if(!inst.snapElements[i].snapping && (ts || bs || ls || rs || first))
				(inst.options.snap.snap && inst.options.snap.snap.call(inst.element, event, $.extend(inst._uiHash(), { snapItem: inst.snapElements[i].item })));
			inst.snapElements[i].snapping = (ts || bs || ls || rs || first);

		};

	}
});

$.ui.plugin.add("draggable", "stack", {
	start: function(event, ui) {

		var o = $(this).data("draggable").options;

		var group = $.makeArray($(o.stack.group)).sort(function(a,b) {
			return (parseInt($(a).css("zIndex"),10) || o.stack.min) - (parseInt($(b).css("zIndex"),10) || o.stack.min);
		});

		$(group).each(function(i) {
			this.style.zIndex = o.stack.min + i;
		});

		this[0].style.zIndex = o.stack.min + group.length;

	}
});

$.ui.plugin.add("draggable", "zIndex", {
	start: function(event, ui) {
		var t = $(ui.helper), o = $(this).data("draggable").options;
		if(t.css("zIndex")) o._zIndex = t.css("zIndex");
		t.css('zIndex', o.zIndex);
	},
	stop: function(event, ui) {
		var o = $(this).data("draggable").options;
		if(o._zIndex) $(ui.helper).css('zIndex', o._zIndex);
	}
});

})(jQuery);
/*
 * jQuery UI Droppable 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Droppables
 *
 * Depends:
 *	ui.core.js
 *	ui.draggable.js
 */
(function($) {

$.widget("ui.droppable", {

	_init: function() {

		var o = this.options, accept = o.accept;
		this.isover = 0; this.isout = 1;

		this.options.accept = this.options.accept && $.isFunction(this.options.accept) ? this.options.accept : function(d) {
			return d.is(accept);
		};

		this.proportions = { width: this.element[0].offsetWidth, height: this.element[0].offsetHeight };

		$.ui.ddmanager.droppables[this.options.scope] = $.ui.ddmanager.droppables[this.options.scope] || [];
		$.ui.ddmanager.droppables[this.options.scope].push(this);

		(this.options.addClasses && this.element.addClass("ui-droppable"));

	},

	destroy: function() {
		var drop = $.ui.ddmanager.droppables[this.options.scope];
		for ( var i = 0; i < drop.length; i++ )
			if ( drop[i] == this )
				drop.splice(i, 1);

		this.element
			.removeClass("ui-droppable ui-droppable-disabled")
			.removeData("droppable")
			.unbind(".droppable");
	},

	_setData: function(key, value) {

		if(key == 'accept') {
			this.options.accept = value && $.isFunction(value) ? value : function(d) {
				return d.is(value);
			};
		} else {
			$.widget.prototype._setData.apply(this, arguments);
		}

	},

	_activate: function(event) {
		var draggable = $.ui.ddmanager.current;
		if(this.options.activeClass) this.element.addClass(this.options.activeClass);
		(draggable && this._trigger('activate', event, this.ui(draggable)));
	},

	_deactivate: function(event) {
		var draggable = $.ui.ddmanager.current;
		if(this.options.activeClass) this.element.removeClass(this.options.activeClass);
		(draggable && this._trigger('deactivate', event, this.ui(draggable)));
	},

	_over: function(event) {
		var draggable = $.ui.ddmanager.current;
		if (!draggable || (draggable.currentItem || draggable.element)[0] == this.element[0]) return; // Bail if draggable and droppable are same element

		if (this.options.accept.call(this.element[0],(draggable.currentItem || draggable.element))) {
			if(this.options.hoverClass) this.element.addClass(this.options.hoverClass);
			this._trigger('over', event, this.ui(draggable));
		}

	},

	_out: function(event) {

		var draggable = $.ui.ddmanager.current;
		if (!draggable || (draggable.currentItem || draggable.element)[0] == this.element[0]) return; // Bail if draggable and droppable are same element

		if (this.options.accept.call(this.element[0],(draggable.currentItem || draggable.element))) {
			if(this.options.hoverClass) this.element.removeClass(this.options.hoverClass);
			this._trigger('out', event, this.ui(draggable));
		}

	},

	_drop: function(event,custom) {

		var draggable = custom || $.ui.ddmanager.current;
		if (!draggable || (draggable.currentItem || draggable.element)[0] == this.element[0]) return false; // Bail if draggable and droppable are same element

		var childrenIntersection = false;
		this.element.find(":data(droppable)").not(".ui-draggable-dragging").each(function() {
			var inst = $.data(this, 'droppable');
			if(inst.options.greedy && $.ui.intersect(draggable, $.extend(inst, { offset: inst.element.offset() }), inst.options.tolerance)) {
				childrenIntersection = true; return false;
			}
		});
		if(childrenIntersection) return false;

		if(this.options.accept.call(this.element[0],(draggable.currentItem || draggable.element))) {
			if(this.options.activeClass) this.element.removeClass(this.options.activeClass);
			if(this.options.hoverClass) this.element.removeClass(this.options.hoverClass);
			this._trigger('drop', event, this.ui(draggable));
			return this.element;
		}

		return false;

	},

	ui: function(c) {
		return {
			draggable: (c.currentItem || c.element),
			helper: c.helper,
			position: c.position,
			absolutePosition: c.positionAbs, //deprecated
			offset: c.positionAbs
		};
	}

});

$.extend($.ui.droppable, {
	version: "1.7.2",
	eventPrefix: 'drop',
	defaults: {
		accept: '*',
		activeClass: false,
		addClasses: true,
		greedy: false,
		hoverClass: false,
		scope: 'default',
		tolerance: 'intersect'
	}
});

$.ui.intersect = function(draggable, droppable, toleranceMode) {

	if (!droppable.offset) return false;


	var x1 = (draggable.positionAbs || draggable.position.absolute).left, x2 = x1 + draggable.helperProportions.width,
		y1 = (draggable.positionAbs || draggable.position.absolute).top, y2 = y1 + draggable.helperProportions.height;
	var l = droppable.offset.left, r = l + droppable.proportions.width,
		t = droppable.offset.top, b = t + droppable.proportions.height;

	switch (toleranceMode) {
		case 'fit':
			return (l < x1 && x2 < r
				&& t < y1 && y2 < b);
			break;
		case 'intersect':
			return (l < x1 + (draggable.helperProportions.width / 2) // Right Half
				&& x2 - (draggable.helperProportions.width / 2) < r // Left Half
				&& t < y1 + (draggable.helperProportions.height / 2) // Bottom Half
				&& y2 - (draggable.helperProportions.height / 2) < b ); // Top Half
			break;
		case 'pointer':
			var draggableLeft = ((draggable.positionAbs || draggable.position.absolute).left + (draggable.clickOffset || draggable.offset.click).left),
				draggableTop = ((draggable.positionAbs || draggable.position.absolute).top + (draggable.clickOffset || draggable.offset.click).top),
				isOver = $.ui.isOver(draggableTop, draggableLeft, t, l, droppable.proportions.height, droppable.proportions.width);
			return isOver;
			break;
		case 'touch':
			return (
					(y1 >= t && y1 <= b) ||	// Top edge touching
					(y2 >= t && y2 <= b) ||	// Bottom edge touching
					(y1 < t && y2 > b)		// Surrounded vertically
				) && (
					(x1 >= l && x1 <= r) ||	// Left edge touching
					(x2 >= l && x2 <= r) ||	// Right edge touching
					(x1 < l && x2 > r)		// Surrounded horizontally
				);
			break;
		default:
			return false;
			break;
		}

};

/*
	This manager tracks offsets of draggables and droppables
*/
$.ui.ddmanager = {
	current: null,
	droppables: { 'default': [] },
	prepareOffsets: function(t, event) {

		var m = $.ui.ddmanager.droppables[t.options.scope];
		var type = event ? event.type : null; // workaround for #2317
		var list = (t.currentItem || t.element).find(":data(droppable)").andSelf();

		droppablesLoop: for (var i = 0; i < m.length; i++) {

			if(m[i].options.disabled || (t && !m[i].options.accept.call(m[i].element[0],(t.currentItem || t.element)))) continue;	//No disabled and non-accepted
			for (var j=0; j < list.length; j++) { if(list[j] == m[i].element[0]) { m[i].proportions.height = 0; continue droppablesLoop; } }; //Filter out elements in the current dragged item
			m[i].visible = m[i].element.css("display") != "none"; if(!m[i].visible) continue; 									//If the element is not visible, continue

			m[i].offset = m[i].element.offset();
			m[i].proportions = { width: m[i].element[0].offsetWidth, height: m[i].element[0].offsetHeight };

			if(type == "mousedown") m[i]._activate.call(m[i], event); //Activate the droppable if used directly from draggables

		}

	},
	drop: function(draggable, event) {

		var dropped = false;
		$.each($.ui.ddmanager.droppables[draggable.options.scope], function() {

			if(!this.options) return;
			if (!this.options.disabled && this.visible && $.ui.intersect(draggable, this, this.options.tolerance))
				dropped = this._drop.call(this, event);

			if (!this.options.disabled && this.visible && this.options.accept.call(this.element[0],(draggable.currentItem || draggable.element))) {
				this.isout = 1; this.isover = 0;
				this._deactivate.call(this, event);
			}

		});
		return dropped;

	},
	drag: function(draggable, event) {

		if(draggable.options.refreshPositions) $.ui.ddmanager.prepareOffsets(draggable, event);


		$.each($.ui.ddmanager.droppables[draggable.options.scope], function() {

			if(this.options.disabled || this.greedyChild || !this.visible) return;
			var intersects = $.ui.intersect(draggable, this, this.options.tolerance);

			var c = !intersects && this.isover == 1 ? 'isout' : (intersects && this.isover == 0 ? 'isover' : null);
			if(!c) return;

			var parentInstance;
			if (this.options.greedy) {
				var parent = this.element.parents(':data(droppable):eq(0)');
				if (parent.length) {
					parentInstance = $.data(parent[0], 'droppable');
					parentInstance.greedyChild = (c == 'isover' ? 1 : 0);
				}
			}

			if (parentInstance && c == 'isover') {
				parentInstance['isover'] = 0;
				parentInstance['isout'] = 1;
				parentInstance._out.call(parentInstance, event);
			}

			this[c] = 1; this[c == 'isout' ? 'isover' : 'isout'] = 0;
			this[c == "isover" ? "_over" : "_out"].call(this, event);

			if (parentInstance && c == 'isout') {
				parentInstance['isout'] = 0;
				parentInstance['isover'] = 1;
				parentInstance._over.call(parentInstance, event);
			}
		});

	}
};

})(jQuery);
/*
 * jQuery UI Resizable 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Resizables
 *
 * Depends:
 *	ui.core.js
 */
(function($) {

$.widget("ui.resizable", $.extend({}, $.ui.mouse, {

	_init: function() {

		var self = this, o = this.options;
		this.element.addClass("ui-resizable");

		$.extend(this, {
			_aspectRatio: !!(o.aspectRatio),
			aspectRatio: o.aspectRatio,
			originalElement: this.element,
			_proportionallyResizeElements: [],
			_helper: o.helper || o.ghost || o.animate ? o.helper || 'ui-resizable-helper' : null
		});

		if(this.element[0].nodeName.match(/canvas|textarea|input|select|button|img/i)) {

			if (/relative/.test(this.element.css('position')) && $.browser.opera)
				this.element.css({ position: 'relative', top: 'auto', left: 'auto' });

			this.element.wrap(
				$('<div class="ui-wrapper" style="overflow: hidden;"></div>').css({
					position: this.element.css('position'),
					width: this.element.outerWidth(),
					height: this.element.outerHeight(),
					top: this.element.css('top'),
					left: this.element.css('left')
				})
			);

			this.element = this.element.parent().data(
				"resizable", this.element.data('resizable')
			);

			this.elementIsWrapper = true;

			this.element.css({ marginLeft: this.originalElement.css("marginLeft"), marginTop: this.originalElement.css("marginTop"), marginRight: this.originalElement.css("marginRight"), marginBottom: this.originalElement.css("marginBottom") });
			this.originalElement.css({ marginLeft: 0, marginTop: 0, marginRight: 0, marginBottom: 0});

			this.originalResizeStyle = this.originalElement.css('resize');
			this.originalElement.css('resize', 'none');

			this._proportionallyResizeElements.push(this.originalElement.css({ position: 'static', zoom: 1, display: 'block' }));

			this.originalElement.css({ margin: this.originalElement.css('margin') });

			this._proportionallyResize();

		}

		this.handles = o.handles || (!$('.ui-resizable-handle', this.element).length ? "e,s,se" : { n: '.ui-resizable-n', e: '.ui-resizable-e', s: '.ui-resizable-s', w: '.ui-resizable-w', se: '.ui-resizable-se', sw: '.ui-resizable-sw', ne: '.ui-resizable-ne', nw: '.ui-resizable-nw' });
		if(this.handles.constructor == String) {

			if(this.handles == 'all') this.handles = 'n,e,s,w,se,sw,ne,nw';
			var n = this.handles.split(","); this.handles = {};

			for(var i = 0; i < n.length; i++) {

				var handle = $.trim(n[i]), hname = 'ui-resizable-'+handle;
				var axis = $('<div class="ui-resizable-handle ' + hname + '"></div>');

				if(/sw|se|ne|nw/.test(handle)) axis.css({ zIndex: ++o.zIndex });

				if ('se' == handle) {
					axis.addClass('ui-icon ui-icon-gripsmall-diagonal-se');
				};

				this.handles[handle] = '.ui-resizable-'+handle;
				this.element.append(axis);
			}

		}

		this._renderAxis = function(target) {

			target = target || this.element;

			for(var i in this.handles) {

				if(this.handles[i].constructor == String)
					this.handles[i] = $(this.handles[i], this.element).show();

				if (this.elementIsWrapper && this.originalElement[0].nodeName.match(/textarea|input|select|button/i)) {

					var axis = $(this.handles[i], this.element), padWrapper = 0;

					padWrapper = /sw|ne|nw|se|n|s/.test(i) ? axis.outerHeight() : axis.outerWidth();

					var padPos = [ 'padding',
						/ne|nw|n/.test(i) ? 'Top' :
						/se|sw|s/.test(i) ? 'Bottom' :
						/^e$/.test(i) ? 'Right' : 'Left' ].join("");

					target.css(padPos, padWrapper);

					this._proportionallyResize();

				}

				if(!$(this.handles[i]).length)
					continue;

			}
		};

		this._renderAxis(this.element);

		this._handles = $('.ui-resizable-handle', this.element)
			.disableSelection();

		this._handles.mouseover(function() {
			if (!self.resizing) {
				if (this.className)
					var axis = this.className.match(/ui-resizable-(se|sw|ne|nw|n|e|s|w)/i);
				self.axis = axis && axis[1] ? axis[1] : 'se';
			}
		});

		if (o.autoHide) {
			this._handles.hide();
			$(this.element)
				.addClass("ui-resizable-autohide")
				.hover(function() {
					$(this).removeClass("ui-resizable-autohide");
					self._handles.show();
				},
				function(){
					if (!self.resizing) {
						$(this).addClass("ui-resizable-autohide");
						self._handles.hide();
					}
				});
		}

		this._mouseInit();

	},

	destroy: function() {

		this._mouseDestroy();

		var _destroy = function(exp) {
			$(exp).removeClass("ui-resizable ui-resizable-disabled ui-resizable-resizing")
				.removeData("resizable").unbind(".resizable").find('.ui-resizable-handle').remove();
		};

		if (this.elementIsWrapper) {
			_destroy(this.element);
			var wrapper = this.element;
			wrapper.parent().append(
				this.originalElement.css({
					position: wrapper.css('position'),
					width: wrapper.outerWidth(),
					height: wrapper.outerHeight(),
					top: wrapper.css('top'),
					left: wrapper.css('left')
				})
			).end().remove();
		}

		this.originalElement.css('resize', this.originalResizeStyle);
		_destroy(this.originalElement);

	},

	_mouseCapture: function(event) {

		var handle = false;
		for(var i in this.handles) {
			if($(this.handles[i])[0] == event.target) handle = true;
		}

		return this.options.disabled || !!handle;

	},

	_mouseStart: function(event) {

		var o = this.options, iniPos = this.element.position(), el = this.element;

		this.resizing = true;
		this.documentScroll = { top: $(document).scrollTop(), left: $(document).scrollLeft() };

		if (el.is('.ui-draggable') || (/absolute/).test(el.css('position'))) {
			el.css({ position: 'absolute', top: iniPos.top, left: iniPos.left });
		}

		if ($.browser.opera && (/relative/).test(el.css('position')))
			el.css({ position: 'relative', top: 'auto', left: 'auto' });

		this._renderProxy();

		var curleft = num(this.helper.css('left')), curtop = num(this.helper.css('top'));

		if (o.containment) {
			curleft += $(o.containment).scrollLeft() || 0;
			curtop += $(o.containment).scrollTop() || 0;
		}

		this.offset = this.helper.offset();
		this.position = { left: curleft, top: curtop };
		this.size = this._helper ? { width: el.outerWidth(), height: el.outerHeight() } : { width: el.width(), height: el.height() };
		this.originalSize = this._helper ? { width: el.outerWidth(), height: el.outerHeight() } : { width: el.width(), height: el.height() };
		this.originalPosition = { left: curleft, top: curtop };
		this.sizeDiff = { width: el.outerWidth() - el.width(), height: el.outerHeight() - el.height() };
		this.originalMousePosition = { left: event.pageX, top: event.pageY };

		this.aspectRatio = (typeof o.aspectRatio == 'number') ? o.aspectRatio : ((this.originalSize.width / this.originalSize.height) || 1);

	    var cursor = $('.ui-resizable-' + this.axis).css('cursor');
	    $('body').css('cursor', cursor == 'auto' ? this.axis + '-resize' : cursor);

		el.addClass("ui-resizable-resizing");
		this._propagate("start", event);
		return true;
	},

	_mouseDrag: function(event) {

		var el = this.helper, o = this.options, props = {},
			self = this, smp = this.originalMousePosition, a = this.axis;

		var dx = (event.pageX-smp.left)||0, dy = (event.pageY-smp.top)||0;
		var trigger = this._change[a];
		if (!trigger) return false;

		var data = trigger.apply(this, [event, dx, dy]), ie6 = $.browser.msie && $.browser.version < 7, csdif = this.sizeDiff;

		if (this._aspectRatio || event.shiftKey)
			data = this._updateRatio(data, event);

		data = this._respectSize(data, event);

		this._propagate("resize", event);

		el.css({
			top: this.position.top + "px", left: this.position.left + "px",
			width: this.size.width + "px", height: this.size.height + "px"
		});

		if (!this._helper && this._proportionallyResizeElements.length)
			this._proportionallyResize();

		this._updateCache(data);

		this._trigger('resize', event, this.ui());

		return false;
	},

	_mouseStop: function(event) {

		this.resizing = false;
		var o = this.options, self = this;

		if(this._helper) {
			var pr = this._proportionallyResizeElements, ista = pr.length && (/textarea/i).test(pr[0].nodeName),
						soffseth = ista && $.ui.hasScroll(pr[0], 'left') /* TODO - jump height */ ? 0 : self.sizeDiff.height,
							soffsetw = ista ? 0 : self.sizeDiff.width;

			var s = { width: (self.size.width - soffsetw), height: (self.size.height - soffseth) },
				left = (parseInt(self.element.css('left'), 10) + (self.position.left - self.originalPosition.left)) || null,
				top = (parseInt(self.element.css('top'), 10) + (self.position.top - self.originalPosition.top)) || null;

			if (!o.animate)
				this.element.css($.extend(s, { top: top, left: left }));

			self.helper.height(self.size.height);
			self.helper.width(self.size.width);

			if (this._helper && !o.animate) this._proportionallyResize();
		}

		$('body').css('cursor', 'auto');

		this.element.removeClass("ui-resizable-resizing");

		this._propagate("stop", event);

		if (this._helper) this.helper.remove();
		return false;

	},

	_updateCache: function(data) {
		var o = this.options;
		this.offset = this.helper.offset();
		if (isNumber(data.left)) this.position.left = data.left;
		if (isNumber(data.top)) this.position.top = data.top;
		if (isNumber(data.height)) this.size.height = data.height;
		if (isNumber(data.width)) this.size.width = data.width;
	},

	_updateRatio: function(data, event) {

		var o = this.options, cpos = this.position, csize = this.size, a = this.axis;

		if (data.height) data.width = (csize.height * this.aspectRatio);
		else if (data.width) data.height = (csize.width / this.aspectRatio);

		if (a == 'sw') {
			data.left = cpos.left + (csize.width - data.width);
			data.top = null;
		}
		if (a == 'nw') {
			data.top = cpos.top + (csize.height - data.height);
			data.left = cpos.left + (csize.width - data.width);
		}

		return data;
	},

	_respectSize: function(data, event) {

		var el = this.helper, o = this.options, pRatio = this._aspectRatio || event.shiftKey, a = this.axis,
				ismaxw = isNumber(data.width) && o.maxWidth && (o.maxWidth < data.width), ismaxh = isNumber(data.height) && o.maxHeight && (o.maxHeight < data.height),
					isminw = isNumber(data.width) && o.minWidth && (o.minWidth > data.width), isminh = isNumber(data.height) && o.minHeight && (o.minHeight > data.height);

		if (isminw) data.width = o.minWidth;
		if (isminh) data.height = o.minHeight;
		if (ismaxw) data.width = o.maxWidth;
		if (ismaxh) data.height = o.maxHeight;

		var dw = this.originalPosition.left + this.originalSize.width, dh = this.position.top + this.size.height;
		var cw = /sw|nw|w/.test(a), ch = /nw|ne|n/.test(a);

		if (isminw && cw) data.left = dw - o.minWidth;
		if (ismaxw && cw) data.left = dw - o.maxWidth;
		if (isminh && ch)	data.top = dh - o.minHeight;
		if (ismaxh && ch)	data.top = dh - o.maxHeight;

		var isNotwh = !data.width && !data.height;
		if (isNotwh && !data.left && data.top) data.top = null;
		else if (isNotwh && !data.top && data.left) data.left = null;

		return data;
	},

	_proportionallyResize: function() {

		var o = this.options;
		if (!this._proportionallyResizeElements.length) return;
		var element = this.helper || this.element;

		for (var i=0; i < this._proportionallyResizeElements.length; i++) {

			var prel = this._proportionallyResizeElements[i];

			if (!this.borderDif) {
				var b = [prel.css('borderTopWidth'), prel.css('borderRightWidth'), prel.css('borderBottomWidth'), prel.css('borderLeftWidth')],
					p = [prel.css('paddingTop'), prel.css('paddingRight'), prel.css('paddingBottom'), prel.css('paddingLeft')];

				this.borderDif = $.map(b, function(v, i) {
					var border = parseInt(v,10)||0, padding = parseInt(p[i],10)||0;
					return border + padding;
				});
			}

			if ($.browser.msie && !(!($(element).is(':hidden') || $(element).parents(':hidden').length)))
				continue;

			prel.css({
				height: (element.height() - this.borderDif[0] - this.borderDif[2]) || 0,
				width: (element.width() - this.borderDif[1] - this.borderDif[3]) || 0
			});

		};

	},

	_renderProxy: function() {

		var el = this.element, o = this.options;
		this.elementOffset = el.offset();

		if(this._helper) {

			this.helper = this.helper || $('<div style="overflow:hidden;"></div>');

			var ie6 = $.browser.msie && $.browser.version < 7, ie6offset = (ie6 ? 1 : 0),
			pxyoffset = ( ie6 ? 2 : -1 );

			this.helper.addClass(this._helper).css({
				width: this.element.outerWidth() + pxyoffset,
				height: this.element.outerHeight() + pxyoffset,
				position: 'absolute',
				left: this.elementOffset.left - ie6offset +'px',
				top: this.elementOffset.top - ie6offset +'px',
				zIndex: ++o.zIndex //TODO: Don't modify option
			});

			this.helper
				.appendTo("body")
				.disableSelection();

		} else {
			this.helper = this.element;
		}

	},

	_change: {
		e: function(event, dx, dy) {
			return { width: this.originalSize.width + dx };
		},
		w: function(event, dx, dy) {
			var o = this.options, cs = this.originalSize, sp = this.originalPosition;
			return { left: sp.left + dx, width: cs.width - dx };
		},
		n: function(event, dx, dy) {
			var o = this.options, cs = this.originalSize, sp = this.originalPosition;
			return { top: sp.top + dy, height: cs.height - dy };
		},
		s: function(event, dx, dy) {
			return { height: this.originalSize.height + dy };
		},
		se: function(event, dx, dy) {
			return $.extend(this._change.s.apply(this, arguments), this._change.e.apply(this, [event, dx, dy]));
		},
		sw: function(event, dx, dy) {
			return $.extend(this._change.s.apply(this, arguments), this._change.w.apply(this, [event, dx, dy]));
		},
		ne: function(event, dx, dy) {
			return $.extend(this._change.n.apply(this, arguments), this._change.e.apply(this, [event, dx, dy]));
		},
		nw: function(event, dx, dy) {
			return $.extend(this._change.n.apply(this, arguments), this._change.w.apply(this, [event, dx, dy]));
		}
	},

	_propagate: function(n, event) {
		$.ui.plugin.call(this, n, [event, this.ui()]);
		(n != "resize" && this._trigger(n, event, this.ui()));
	},

	plugins: {},

	ui: function() {
		return {
			originalElement: this.originalElement,
			element: this.element,
			helper: this.helper,
			position: this.position,
			size: this.size,
			originalSize: this.originalSize,
			originalPosition: this.originalPosition
		};
	}

}));

$.extend($.ui.resizable, {
	version: "1.7.2",
	eventPrefix: "resize",
	defaults: {
		alsoResize: false,
		animate: false,
		animateDuration: "slow",
		animateEasing: "swing",
		aspectRatio: false,
		autoHide: false,
		cancel: ":input,option",
		containment: false,
		delay: 0,
		distance: 1,
		ghost: false,
		grid: false,
		handles: "e,s,se",
		helper: false,
		maxHeight: null,
		maxWidth: null,
		minHeight: 10,
		minWidth: 10,
		zIndex: 1000
	}
});

/*
 * Resizable Extensions
 */

$.ui.plugin.add("resizable", "alsoResize", {

	start: function(event, ui) {

		var self = $(this).data("resizable"), o = self.options;

		_store = function(exp) {
			$(exp).each(function() {
				$(this).data("resizable-alsoresize", {
					width: parseInt($(this).width(), 10), height: parseInt($(this).height(), 10),
					left: parseInt($(this).css('left'), 10), top: parseInt($(this).css('top'), 10)
				});
			});
		};

		if (typeof(o.alsoResize) == 'object' && !o.alsoResize.parentNode) {
			if (o.alsoResize.length) { o.alsoResize = o.alsoResize[0];	_store(o.alsoResize); }
			else { $.each(o.alsoResize, function(exp, c) { _store(exp); }); }
		}else{
			_store(o.alsoResize);
		}
	},

	resize: function(event, ui){
		var self = $(this).data("resizable"), o = self.options, os = self.originalSize, op = self.originalPosition;

		var delta = {
			height: (self.size.height - os.height) || 0, width: (self.size.width - os.width) || 0,
			top: (self.position.top - op.top) || 0, left: (self.position.left - op.left) || 0
		},

		_alsoResize = function(exp, c) {
			$(exp).each(function() {
				var el = $(this), start = $(this).data("resizable-alsoresize"), style = {}, css = c && c.length ? c : ['width', 'height', 'top', 'left'];

				$.each(css || ['width', 'height', 'top', 'left'], function(i, prop) {
					var sum = (start[prop]||0) + (delta[prop]||0);
					if (sum && sum >= 0)
						style[prop] = sum || null;
				});

				if (/relative/.test(el.css('position')) && $.browser.opera) {
					self._revertToRelativePosition = true;
					el.css({ position: 'absolute', top: 'auto', left: 'auto' });
				}

				el.css(style);
			});
		};

		if (typeof(o.alsoResize) == 'object' && !o.alsoResize.nodeType) {
			$.each(o.alsoResize, function(exp, c) { _alsoResize(exp, c); });
		}else{
			_alsoResize(o.alsoResize);
		}
	},

	stop: function(event, ui){
		var self = $(this).data("resizable");

		if (self._revertToRelativePosition && $.browser.opera) {
			self._revertToRelativePosition = false;
			el.css({ position: 'relative' });
		}

		$(this).removeData("resizable-alsoresize-start");
	}
});

$.ui.plugin.add("resizable", "animate", {

	stop: function(event, ui) {
		var self = $(this).data("resizable"), o = self.options;

		var pr = self._proportionallyResizeElements, ista = pr.length && (/textarea/i).test(pr[0].nodeName),
					soffseth = ista && $.ui.hasScroll(pr[0], 'left') /* TODO - jump height */ ? 0 : self.sizeDiff.height,
						soffsetw = ista ? 0 : self.sizeDiff.width;

		var style = { width: (self.size.width - soffsetw), height: (self.size.height - soffseth) },
					left = (parseInt(self.element.css('left'), 10) + (self.position.left - self.originalPosition.left)) || null,
						top = (parseInt(self.element.css('top'), 10) + (self.position.top - self.originalPosition.top)) || null;

		self.element.animate(
			$.extend(style, top && left ? { top: top, left: left } : {}), {
				duration: o.animateDuration,
				easing: o.animateEasing,
				step: function() {

					var data = {
						width: parseInt(self.element.css('width'), 10),
						height: parseInt(self.element.css('height'), 10),
						top: parseInt(self.element.css('top'), 10),
						left: parseInt(self.element.css('left'), 10)
					};

					if (pr && pr.length) $(pr[0]).css({ width: data.width, height: data.height });

					self._updateCache(data);
					self._propagate("resize", event);

				}
			}
		);
	}

});

$.ui.plugin.add("resizable", "containment", {

	start: function(event, ui) {
		var self = $(this).data("resizable"), o = self.options, el = self.element;
		var oc = o.containment,	ce = (oc instanceof $) ? oc.get(0) : (/parent/.test(oc)) ? el.parent().get(0) : oc;
		if (!ce) return;

		self.containerElement = $(ce);

		if (/document/.test(oc) || oc == document) {
			self.containerOffset = { left: 0, top: 0 };
			self.containerPosition = { left: 0, top: 0 };

			self.parentData = {
				element: $(document), left: 0, top: 0,
				width: $(document).width(), height: $(document).height() || document.body.parentNode.scrollHeight
			};
		}

		else {
			var element = $(ce), p = [];
			$([ "Top", "Right", "Left", "Bottom" ]).each(function(i, name) { p[i] = num(element.css("padding" + name)); });

			self.containerOffset = element.offset();
			self.containerPosition = element.position();
			self.containerSize = { height: (element.innerHeight() - p[3]), width: (element.innerWidth() - p[1]) };

			var co = self.containerOffset, ch = self.containerSize.height,	cw = self.containerSize.width,
						width = ($.ui.hasScroll(ce, "left") ? ce.scrollWidth : cw ), height = ($.ui.hasScroll(ce) ? ce.scrollHeight : ch);

			self.parentData = {
				element: ce, left: co.left, top: co.top, width: width, height: height
			};
		}
	},

	resize: function(event, ui) {
		var self = $(this).data("resizable"), o = self.options,
				ps = self.containerSize, co = self.containerOffset, cs = self.size, cp = self.position,
				pRatio = self._aspectRatio || event.shiftKey, cop = { top:0, left:0 }, ce = self.containerElement;

		if (ce[0] != document && (/static/).test(ce.css('position'))) cop = co;

		if (cp.left < (self._helper ? co.left : 0)) {
			self.size.width = self.size.width + (self._helper ? (self.position.left - co.left) : (self.position.left - cop.left));
			if (pRatio) self.size.height = self.size.width / o.aspectRatio;
			self.position.left = o.helper ? co.left : 0;
		}

		if (cp.top < (self._helper ? co.top : 0)) {
			self.size.height = self.size.height + (self._helper ? (self.position.top - co.top) : self.position.top);
			if (pRatio) self.size.width = self.size.height * o.aspectRatio;
			self.position.top = self._helper ? co.top : 0;
		}

		self.offset.left = self.parentData.left+self.position.left;
		self.offset.top = self.parentData.top+self.position.top;

		var woset = Math.abs( (self._helper ? self.offset.left - cop.left : (self.offset.left - cop.left)) + self.sizeDiff.width ),
					hoset = Math.abs( (self._helper ? self.offset.top - cop.top : (self.offset.top - co.top)) + self.sizeDiff.height );

		var isParent = self.containerElement.get(0) == self.element.parent().get(0),
		    isOffsetRelative = /relative|absolute/.test(self.containerElement.css('position'));

		if(isParent && isOffsetRelative) woset -= self.parentData.left;

		if (woset + self.size.width >= self.parentData.width) {
			self.size.width = self.parentData.width - woset;
			if (pRatio) self.size.height = self.size.width / self.aspectRatio;
		}

		if (hoset + self.size.height >= self.parentData.height) {
			self.size.height = self.parentData.height - hoset;
			if (pRatio) self.size.width = self.size.height * self.aspectRatio;
		}
	},

	stop: function(event, ui){
		var self = $(this).data("resizable"), o = self.options, cp = self.position,
				co = self.containerOffset, cop = self.containerPosition, ce = self.containerElement;

		var helper = $(self.helper), ho = helper.offset(), w = helper.outerWidth() - self.sizeDiff.width, h = helper.outerHeight() - self.sizeDiff.height;

		if (self._helper && !o.animate && (/relative/).test(ce.css('position')))
			$(this).css({ left: ho.left - cop.left - co.left, width: w, height: h });

		if (self._helper && !o.animate && (/static/).test(ce.css('position')))
			$(this).css({ left: ho.left - cop.left - co.left, width: w, height: h });

	}
});

$.ui.plugin.add("resizable", "ghost", {

	start: function(event, ui) {

		var self = $(this).data("resizable"), o = self.options, cs = self.size;

		self.ghost = self.originalElement.clone();
		self.ghost
			.css({ opacity: .25, display: 'block', position: 'relative', height: cs.height, width: cs.width, margin: 0, left: 0, top: 0 })
			.addClass('ui-resizable-ghost')
			.addClass(typeof o.ghost == 'string' ? o.ghost : '');

		self.ghost.appendTo(self.helper);

	},

	resize: function(event, ui){
		var self = $(this).data("resizable"), o = self.options;
		if (self.ghost) self.ghost.css({ position: 'relative', height: self.size.height, width: self.size.width });
	},

	stop: function(event, ui){
		var self = $(this).data("resizable"), o = self.options;
		if (self.ghost && self.helper) self.helper.get(0).removeChild(self.ghost.get(0));
	}

});

$.ui.plugin.add("resizable", "grid", {

	resize: function(event, ui) {
		var self = $(this).data("resizable"), o = self.options, cs = self.size, os = self.originalSize, op = self.originalPosition, a = self.axis, ratio = o._aspectRatio || event.shiftKey;
		o.grid = typeof o.grid == "number" ? [o.grid, o.grid] : o.grid;
		var ox = Math.round((cs.width - os.width) / (o.grid[0]||1)) * (o.grid[0]||1), oy = Math.round((cs.height - os.height) / (o.grid[1]||1)) * (o.grid[1]||1);

		if (/^(se|s|e)$/.test(a)) {
			self.size.width = os.width + ox;
			self.size.height = os.height + oy;
		}
		else if (/^(ne)$/.test(a)) {
			self.size.width = os.width + ox;
			self.size.height = os.height + oy;
			self.position.top = op.top - oy;
		}
		else if (/^(sw)$/.test(a)) {
			self.size.width = os.width + ox;
			self.size.height = os.height + oy;
			self.position.left = op.left - ox;
		}
		else {
			self.size.width = os.width + ox;
			self.size.height = os.height + oy;
			self.position.top = op.top - oy;
			self.position.left = op.left - ox;
		}
	}

});

var num = function(v) {
	return parseInt(v, 10) || 0;
};

var isNumber = function(value) {
	return !isNaN(parseInt(value, 10));
};

})(jQuery);
/*
 * jQuery UI Selectable 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Selectables
 *
 * Depends:
 *	ui.core.js
 */
(function($) {

$.widget("ui.selectable", $.extend({}, $.ui.mouse, {

	_init: function() {
		var self = this;

		this.element.addClass("ui-selectable");

		this.dragged = false;

		var selectees;
		this.refresh = function() {
			selectees = $(self.options.filter, self.element[0]);
			selectees.each(function() {
				var $this = $(this);
				var pos = $this.offset();
				$.data(this, "selectable-item", {
					element: this,
					$element: $this,
					left: pos.left,
					top: pos.top,
					right: pos.left + $this.outerWidth(),
					bottom: pos.top + $this.outerHeight(),
					startselected: false,
					selected: $this.hasClass('ui-selected'),
					selecting: $this.hasClass('ui-selecting'),
					unselecting: $this.hasClass('ui-unselecting')
				});
			});
		};
		this.refresh();

		this.selectees = selectees.addClass("ui-selectee");

		this._mouseInit();

		this.helper = $(document.createElement('div'))
			.css({border:'1px dotted black'})
			.addClass("ui-selectable-helper");
	},

	destroy: function() {
		this.element
			.removeClass("ui-selectable ui-selectable-disabled")
			.removeData("selectable")
			.unbind(".selectable");
		this._mouseDestroy();
	},

	_mouseStart: function(event) {
		var self = this;

		this.opos = [event.pageX, event.pageY];

		if (this.options.disabled)
			return;

		var options = this.options;

		this.selectees = $(options.filter, this.element[0]);

		this._trigger("start", event);

		$(options.appendTo).append(this.helper);
		this.helper.css({
			"z-index": 100,
			"position": "absolute",
			"left": event.clientX,
			"top": event.clientY,
			"width": 0,
			"height": 0
		});

		if (options.autoRefresh) {
			this.refresh();
		}

		this.selectees.filter('.ui-selected').each(function() {
			var selectee = $.data(this, "selectable-item");
			selectee.startselected = true;
			if (!event.metaKey) {
				selectee.$element.removeClass('ui-selected');
				selectee.selected = false;
				selectee.$element.addClass('ui-unselecting');
				selectee.unselecting = true;
				self._trigger("unselecting", event, {
					unselecting: selectee.element
				});
			}
		});

		$(event.target).parents().andSelf().each(function() {
			var selectee = $.data(this, "selectable-item");
			if (selectee) {
				selectee.$element.removeClass("ui-unselecting").addClass('ui-selecting');
				selectee.unselecting = false;
				selectee.selecting = true;
				selectee.selected = true;
				self._trigger("selecting", event, {
					selecting: selectee.element
				});
				return false;
			}
		});

	},

	_mouseDrag: function(event) {
		var self = this;
		this.dragged = true;

		if (this.options.disabled)
			return;

		var options = this.options;

		var x1 = this.opos[0], y1 = this.opos[1], x2 = event.pageX, y2 = event.pageY;
		if (x1 > x2) { var tmp = x2; x2 = x1; x1 = tmp; }
		if (y1 > y2) { var tmp = y2; y2 = y1; y1 = tmp; }
		this.helper.css({left: x1, top: y1, width: x2-x1, height: y2-y1});

		this.selectees.each(function() {
			var selectee = $.data(this, "selectable-item");
			if (!selectee || selectee.element == self.element[0])
				return;
			var hit = false;
			if (options.tolerance == 'touch') {
				hit = ( !(selectee.left > x2 || selectee.right < x1 || selectee.top > y2 || selectee.bottom < y1) );
			} else if (options.tolerance == 'fit') {
				hit = (selectee.left > x1 && selectee.right < x2 && selectee.top > y1 && selectee.bottom < y2);
			}

			if (hit) {
				if (selectee.selected) {
					selectee.$element.removeClass('ui-selected');
					selectee.selected = false;
				}
				if (selectee.unselecting) {
					selectee.$element.removeClass('ui-unselecting');
					selectee.unselecting = false;
				}
				if (!selectee.selecting) {
					selectee.$element.addClass('ui-selecting');
					selectee.selecting = true;
					self._trigger("selecting", event, {
						selecting: selectee.element
					});
				}
			} else {
				if (selectee.selecting) {
					if (event.metaKey && selectee.startselected) {
						selectee.$element.removeClass('ui-selecting');
						selectee.selecting = false;
						selectee.$element.addClass('ui-selected');
						selectee.selected = true;
					} else {
						selectee.$element.removeClass('ui-selecting');
						selectee.selecting = false;
						if (selectee.startselected) {
							selectee.$element.addClass('ui-unselecting');
							selectee.unselecting = true;
						}
						self._trigger("unselecting", event, {
							unselecting: selectee.element
						});
					}
				}
				if (selectee.selected) {
					if (!event.metaKey && !selectee.startselected) {
						selectee.$element.removeClass('ui-selected');
						selectee.selected = false;

						selectee.$element.addClass('ui-unselecting');
						selectee.unselecting = true;
						self._trigger("unselecting", event, {
							unselecting: selectee.element
						});
					}
				}
			}
		});

		return false;
	},

	_mouseStop: function(event) {
		var self = this;

		this.dragged = false;

		var options = this.options;

		$('.ui-unselecting', this.element[0]).each(function() {
			var selectee = $.data(this, "selectable-item");
			selectee.$element.removeClass('ui-unselecting');
			selectee.unselecting = false;
			selectee.startselected = false;
			self._trigger("unselected", event, {
				unselected: selectee.element
			});
		});
		$('.ui-selecting', this.element[0]).each(function() {
			var selectee = $.data(this, "selectable-item");
			selectee.$element.removeClass('ui-selecting').addClass('ui-selected');
			selectee.selecting = false;
			selectee.selected = true;
			selectee.startselected = true;
			self._trigger("selected", event, {
				selected: selectee.element
			});
		});
		this._trigger("stop", event);

		this.helper.remove();

		return false;
	}

}));

$.extend($.ui.selectable, {
	version: "1.7.2",
	defaults: {
		appendTo: 'body',
		autoRefresh: true,
		cancel: ":input,option",
		delay: 0,
		distance: 0,
		filter: '*',
		tolerance: 'touch'
	}
});

})(jQuery);
/*
 * jQuery UI Sortable 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Sortables
 *
 * Depends:
 *	ui.core.js
 */
(function($) {

$.widget("ui.sortable", $.extend({}, $.ui.mouse, {
	_init: function() {

		var o = this.options;
		this.containerCache = {};
		this.element.addClass("ui-sortable");

		this.refresh();

		this.floating = this.items.length ? (/left|right/).test(this.items[0].item.css('float')) : false;

		this.offset = this.element.offset();

		this._mouseInit();

	},

	destroy: function() {
		this.element
			.removeClass("ui-sortable ui-sortable-disabled")
			.removeData("sortable")
			.unbind(".sortable");
		this._mouseDestroy();

		for ( var i = this.items.length - 1; i >= 0; i-- )
			this.items[i].item.removeData("sortable-item");
	},

	_mouseCapture: function(event, overrideHandle) {

		if (this.reverting) {
			return false;
		}

		if(this.options.disabled || this.options.type == 'static') return false;

		this._refreshItems(event);

		var currentItem = null, self = this, nodes = $(event.target).parents().each(function() {
			if($.data(this, 'sortable-item') == self) {
				currentItem = $(this);
				return false;
			}
		});
		if($.data(event.target, 'sortable-item') == self) currentItem = $(event.target);

		if(!currentItem) return false;
		if(this.options.handle && !overrideHandle) {
			var validHandle = false;

			$(this.options.handle, currentItem).find("*").andSelf().each(function() { if(this == event.target) validHandle = true; });
			if(!validHandle) return false;
		}

		this.currentItem = currentItem;
		this._removeCurrentsFromItems();
		return true;

	},

	_mouseStart: function(event, overrideHandle, noActivation) {

		var o = this.options, self = this;
		this.currentContainer = this;

		this.refreshPositions();

		this.helper = this._createHelper(event);

		this._cacheHelperProportions();

		/*
		 * - Position generation -
		 * This block generates everything position related - it's the core of draggables.
		 */

		this._cacheMargins();

		this.scrollParent = this.helper.scrollParent();

		this.offset = this.currentItem.offset();
		this.offset = {
			top: this.offset.top - this.margins.top,
			left: this.offset.left - this.margins.left
		};

		this.helper.css("position", "absolute");
		this.cssPosition = this.helper.css("position");

		$.extend(this.offset, {
			click: { //Where the click happened, relative to the element
				left: event.pageX - this.offset.left,
				top: event.pageY - this.offset.top
			},
			parent: this._getParentOffset(),
			relative: this._getRelativeOffset() //This is a relative to absolute position minus the actual position calculation - only used for relative positioned helper
		});

		this.originalPosition = this._generatePosition(event);
		this.originalPageX = event.pageX;
		this.originalPageY = event.pageY;

		if(o.cursorAt)
			this._adjustOffsetFromHelper(o.cursorAt);

		this.domPosition = { prev: this.currentItem.prev()[0], parent: this.currentItem.parent()[0] };

		if(this.helper[0] != this.currentItem[0]) {
			this.currentItem.hide();
		}

		this._createPlaceholder();

		if(o.containment)
			this._setContainment();

		if(o.cursor) { // cursor option
			if ($('body').css("cursor")) this._storedCursor = $('body').css("cursor");
			$('body').css("cursor", o.cursor);
		}

		if(o.opacity) { // opacity option
			if (this.helper.css("opacity")) this._storedOpacity = this.helper.css("opacity");
			this.helper.css("opacity", o.opacity);
		}

		if(o.zIndex) { // zIndex option
			if (this.helper.css("zIndex")) this._storedZIndex = this.helper.css("zIndex");
			this.helper.css("zIndex", o.zIndex);
		}

		if(this.scrollParent[0] != document && this.scrollParent[0].tagName != 'HTML')
			this.overflowOffset = this.scrollParent.offset();

		this._trigger("start", event, this._uiHash());

		if(!this._preserveHelperProportions)
			this._cacheHelperProportions();


		if(!noActivation) {
			 for (var i = this.containers.length - 1; i >= 0; i--) { this.containers[i]._trigger("activate", event, self._uiHash(this)); }
		}

		if($.ui.ddmanager)
			$.ui.ddmanager.current = this;

		if ($.ui.ddmanager && !o.dropBehaviour)
			$.ui.ddmanager.prepareOffsets(this, event);

		this.dragging = true;

		this.helper.addClass("ui-sortable-helper");
		this._mouseDrag(event); //Execute the drag once - this causes the helper not to be visible before getting its correct position
		return true;

	},

	_mouseDrag: function(event) {

		this.position = this._generatePosition(event);
		this.positionAbs = this._convertPositionTo("absolute");

		if (!this.lastPositionAbs) {
			this.lastPositionAbs = this.positionAbs;
		}

		if(this.options.scroll) {
			var o = this.options, scrolled = false;
			if(this.scrollParent[0] != document && this.scrollParent[0].tagName != 'HTML') {

				if((this.overflowOffset.top + this.scrollParent[0].offsetHeight) - event.pageY < o.scrollSensitivity)
					this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop + o.scrollSpeed;
				else if(event.pageY - this.overflowOffset.top < o.scrollSensitivity)
					this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop - o.scrollSpeed;

				if((this.overflowOffset.left + this.scrollParent[0].offsetWidth) - event.pageX < o.scrollSensitivity)
					this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft + o.scrollSpeed;
				else if(event.pageX - this.overflowOffset.left < o.scrollSensitivity)
					this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft - o.scrollSpeed;

			} else {

				if(event.pageY - $(document).scrollTop() < o.scrollSensitivity)
					scrolled = $(document).scrollTop($(document).scrollTop() - o.scrollSpeed);
				else if($(window).height() - (event.pageY - $(document).scrollTop()) < o.scrollSensitivity)
					scrolled = $(document).scrollTop($(document).scrollTop() + o.scrollSpeed);

				if(event.pageX - $(document).scrollLeft() < o.scrollSensitivity)
					scrolled = $(document).scrollLeft($(document).scrollLeft() - o.scrollSpeed);
				else if($(window).width() - (event.pageX - $(document).scrollLeft()) < o.scrollSensitivity)
					scrolled = $(document).scrollLeft($(document).scrollLeft() + o.scrollSpeed);

			}

			if(scrolled !== false && $.ui.ddmanager && !o.dropBehaviour)
				$.ui.ddmanager.prepareOffsets(this, event);
		}

		this.positionAbs = this._convertPositionTo("absolute");

		if(!this.options.axis || this.options.axis != "y") this.helper[0].style.left = this.position.left+'px';
		if(!this.options.axis || this.options.axis != "x") this.helper[0].style.top = this.position.top+'px';

		for (var i = this.items.length - 1; i >= 0; i--) {

			var item = this.items[i], itemElement = item.item[0], intersection = this._intersectsWithPointer(item);
			if (!intersection) continue;

			if(itemElement != this.currentItem[0] //cannot intersect with itself
				&&	this.placeholder[intersection == 1 ? "next" : "prev"]()[0] != itemElement //no useless actions that have been done before
				&&	!$.ui.contains(this.placeholder[0], itemElement) //no action if the item moved is the parent of the item checked
				&& (this.options.type == 'semi-dynamic' ? !$.ui.contains(this.element[0], itemElement) : true)
			) {

				this.direction = intersection == 1 ? "down" : "up";

				if (this.options.tolerance == "pointer" || this._intersectsWithSides(item)) {
					this._rearrange(event, item);
				} else {
					break;
				}

				this._trigger("change", event, this._uiHash());
				break;
			}
		}

		this._contactContainers(event);

		if($.ui.ddmanager) $.ui.ddmanager.drag(this, event);

		this._trigger('sort', event, this._uiHash());

		this.lastPositionAbs = this.positionAbs;
		return false;

	},

	_mouseStop: function(event, noPropagation) {

		if(!event) return;

		if ($.ui.ddmanager && !this.options.dropBehaviour)
			$.ui.ddmanager.drop(this, event);

		if(this.options.revert) {
			var self = this;
			var cur = self.placeholder.offset();

			self.reverting = true;

			$(this.helper).animate({
				left: cur.left - this.offset.parent.left - self.margins.left + (this.offsetParent[0] == document.body ? 0 : this.offsetParent[0].scrollLeft),
				top: cur.top - this.offset.parent.top - self.margins.top + (this.offsetParent[0] == document.body ? 0 : this.offsetParent[0].scrollTop)
			}, parseInt(this.options.revert, 10) || 500, function() {
				self._clear(event);
			});
		} else {
			this._clear(event, noPropagation);
		}

		return false;

	},

	cancel: function() {

		var self = this;

		if(this.dragging) {

			this._mouseUp();

			if(this.options.helper == "original")
				this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper");
			else
				this.currentItem.show();

			for (var i = this.containers.length - 1; i >= 0; i--){
				this.containers[i]._trigger("deactivate", null, self._uiHash(this));
				if(this.containers[i].containerCache.over) {
					this.containers[i]._trigger("out", null, self._uiHash(this));
					this.containers[i].containerCache.over = 0;
				}
			}

		}

		if(this.placeholder[0].parentNode) this.placeholder[0].parentNode.removeChild(this.placeholder[0]);
		if(this.options.helper != "original" && this.helper && this.helper[0].parentNode) this.helper.remove();

		$.extend(this, {
			helper: null,
			dragging: false,
			reverting: false,
			_noFinalSort: null
		});

		if(this.domPosition.prev) {
			$(this.domPosition.prev).after(this.currentItem);
		} else {
			$(this.domPosition.parent).prepend(this.currentItem);
		}

		return true;

	},

	serialize: function(o) {

		var items = this._getItemsAsjQuery(o && o.connected);
		var str = []; o = o || {};

		$(items).each(function() {
			var res = ($(o.item || this).attr(o.attribute || 'id') || '').match(o.expression || (/(.+)[-=_](.+)/));
			if(res) str.push((o.key || res[1]+'[]')+'='+(o.key && o.expression ? res[1] : res[2]));
		});

		return str.join('&');

	},

	toArray: function(o) {

		var items = this._getItemsAsjQuery(o && o.connected);
		var ret = []; o = o || {};

		items.each(function() { ret.push($(o.item || this).attr(o.attribute || 'id') || ''); });
		return ret;

	},

	/* Be careful with the following core functions */
	_intersectsWith: function(item) {

		var x1 = this.positionAbs.left,
			x2 = x1 + this.helperProportions.width,
			y1 = this.positionAbs.top,
			y2 = y1 + this.helperProportions.height;

		var l = item.left,
			r = l + item.width,
			t = item.top,
			b = t + item.height;

		var dyClick = this.offset.click.top,
			dxClick = this.offset.click.left;

		var isOverElement = (y1 + dyClick) > t && (y1 + dyClick) < b && (x1 + dxClick) > l && (x1 + dxClick) < r;

		if(	   this.options.tolerance == "pointer"
			|| this.options.forcePointerForContainers
			|| (this.options.tolerance != "pointer" && this.helperProportions[this.floating ? 'width' : 'height'] > item[this.floating ? 'width' : 'height'])
		) {
			return isOverElement;
		} else {

			return (l < x1 + (this.helperProportions.width / 2) // Right Half
				&& x2 - (this.helperProportions.width / 2) < r // Left Half
				&& t < y1 + (this.helperProportions.height / 2) // Bottom Half
				&& y2 - (this.helperProportions.height / 2) < b ); // Top Half

		}
	},

	_intersectsWithPointer: function(item) {

		var isOverElementHeight = $.ui.isOverAxis(this.positionAbs.top + this.offset.click.top, item.top, item.height),
			isOverElementWidth = $.ui.isOverAxis(this.positionAbs.left + this.offset.click.left, item.left, item.width),
			isOverElement = isOverElementHeight && isOverElementWidth,
			verticalDirection = this._getDragVerticalDirection(),
			horizontalDirection = this._getDragHorizontalDirection();

		if (!isOverElement)
			return false;

		return this.floating ?
			( ((horizontalDirection && horizontalDirection == "right") || verticalDirection == "down") ? 2 : 1 )
			: ( verticalDirection && (verticalDirection == "down" ? 2 : 1) );

	},

	_intersectsWithSides: function(item) {

		var isOverBottomHalf = $.ui.isOverAxis(this.positionAbs.top + this.offset.click.top, item.top + (item.height/2), item.height),
			isOverRightHalf = $.ui.isOverAxis(this.positionAbs.left + this.offset.click.left, item.left + (item.width/2), item.width),
			verticalDirection = this._getDragVerticalDirection(),
			horizontalDirection = this._getDragHorizontalDirection();

		if (this.floating && horizontalDirection) {
			return ((horizontalDirection == "right" && isOverRightHalf) || (horizontalDirection == "left" && !isOverRightHalf));
		} else {
			return verticalDirection && ((verticalDirection == "down" && isOverBottomHalf) || (verticalDirection == "up" && !isOverBottomHalf));
		}

	},

	_getDragVerticalDirection: function() {
		var delta = this.positionAbs.top - this.lastPositionAbs.top;
		return delta != 0 && (delta > 0 ? "down" : "up");
	},

	_getDragHorizontalDirection: function() {
		var delta = this.positionAbs.left - this.lastPositionAbs.left;
		return delta != 0 && (delta > 0 ? "right" : "left");
	},

	refresh: function(event) {
		this._refreshItems(event);
		this.refreshPositions();
	},

	_connectWith: function() {
		var options = this.options;
		return options.connectWith.constructor == String
			? [options.connectWith]
			: options.connectWith;
	},

	_getItemsAsjQuery: function(connected) {

		var self = this;
		var items = [];
		var queries = [];
		var connectWith = this._connectWith();

		if(connectWith && connected) {
			for (var i = connectWith.length - 1; i >= 0; i--){
				var cur = $(connectWith[i]);
				for (var j = cur.length - 1; j >= 0; j--){
					var inst = $.data(cur[j], 'sortable');
					if(inst && inst != this && !inst.options.disabled) {
						queries.push([$.isFunction(inst.options.items) ? inst.options.items.call(inst.element) : $(inst.options.items, inst.element).not(".ui-sortable-helper"), inst]);
					}
				};
			};
		}

		queries.push([$.isFunction(this.options.items) ? this.options.items.call(this.element, null, { options: this.options, item: this.currentItem }) : $(this.options.items, this.element).not(".ui-sortable-helper"), this]);

		for (var i = queries.length - 1; i >= 0; i--){
			queries[i][0].each(function() {
				items.push(this);
			});
		};

		return $(items);

	},

	_removeCurrentsFromItems: function() {

		var list = this.currentItem.find(":data(sortable-item)");

		for (var i=0; i < this.items.length; i++) {

			for (var j=0; j < list.length; j++) {
				if(list[j] == this.items[i].item[0])
					this.items.splice(i,1);
			};

		};

	},

	_refreshItems: function(event) {

		this.items = [];
		this.containers = [this];
		var items = this.items;
		var self = this;
		var queries = [[$.isFunction(this.options.items) ? this.options.items.call(this.element[0], event, { item: this.currentItem }) : $(this.options.items, this.element), this]];
		var connectWith = this._connectWith();

		if(connectWith) {
			for (var i = connectWith.length - 1; i >= 0; i--){
				var cur = $(connectWith[i]);
				for (var j = cur.length - 1; j >= 0; j--){
					var inst = $.data(cur[j], 'sortable');
					if(inst && inst != this && !inst.options.disabled) {
						queries.push([$.isFunction(inst.options.items) ? inst.options.items.call(inst.element[0], event, { item: this.currentItem }) : $(inst.options.items, inst.element), inst]);
						this.containers.push(inst);
					}
				};
			};
		}

		for (var i = queries.length - 1; i >= 0; i--) {
			var targetData = queries[i][1];
			var _queries = queries[i][0];

			for (var j=0, queriesLength = _queries.length; j < queriesLength; j++) {
				var item = $(_queries[j]);

				item.data('sortable-item', targetData); // Data for target checking (mouse manager)

				items.push({
					item: item,
					instance: targetData,
					width: 0, height: 0,
					left: 0, top: 0
				});
			};
		};

	},

	refreshPositions: function(fast) {

		if(this.offsetParent && this.helper) {
			this.offset.parent = this._getParentOffset();
		}

		for (var i = this.items.length - 1; i >= 0; i--){
			var item = this.items[i];

			if(item.instance != this.currentContainer && this.currentContainer && item.item[0] != this.currentItem[0])
				continue;

			var t = this.options.toleranceElement ? $(this.options.toleranceElement, item.item) : item.item;

			if (!fast) {
				item.width = t.outerWidth();
				item.height = t.outerHeight();
			}

			var p = t.offset();
			item.left = p.left;
			item.top = p.top;
		};

		if(this.options.custom && this.options.custom.refreshContainers) {
			this.options.custom.refreshContainers.call(this);
		} else {
			for (var i = this.containers.length - 1; i >= 0; i--){
				var p = this.containers[i].element.offset();
				this.containers[i].containerCache.left = p.left;
				this.containers[i].containerCache.top = p.top;
				this.containers[i].containerCache.width	= this.containers[i].element.outerWidth();
				this.containers[i].containerCache.height = this.containers[i].element.outerHeight();
			};
		}

	},

	_createPlaceholder: function(that) {

		var self = that || this, o = self.options;

		if(!o.placeholder || o.placeholder.constructor == String) {
			var className = o.placeholder;
			o.placeholder = {
				element: function() {

					var el = $(document.createElement(self.currentItem[0].nodeName))
						.addClass(className || self.currentItem[0].className+" ui-sortable-placeholder")
						.removeClass("ui-sortable-helper")[0];

					if(!className)
						el.style.visibility = "hidden";

					return el;
				},
				update: function(container, p) {

					if(className && !o.forcePlaceholderSize) return;

					if(!p.height()) { p.height(self.currentItem.innerHeight() - parseInt(self.currentItem.css('paddingTop')||0, 10) - parseInt(self.currentItem.css('paddingBottom')||0, 10)); };
					if(!p.width()) { p.width(self.currentItem.innerWidth() - parseInt(self.currentItem.css('paddingLeft')||0, 10) - parseInt(self.currentItem.css('paddingRight')||0, 10)); };
				}
			};
		}

		self.placeholder = $(o.placeholder.element.call(self.element, self.currentItem));

		self.currentItem.after(self.placeholder);

		o.placeholder.update(self, self.placeholder);

	},

	_contactContainers: function(event) {
		for (var i = this.containers.length - 1; i >= 0; i--){

			if(this._intersectsWith(this.containers[i].containerCache)) {
				if(!this.containers[i].containerCache.over) {

					if(this.currentContainer != this.containers[i]) {

						var dist = 10000; var itemWithLeastDistance = null; var base = this.positionAbs[this.containers[i].floating ? 'left' : 'top'];
						for (var j = this.items.length - 1; j >= 0; j--) {
							if(!$.ui.contains(this.containers[i].element[0], this.items[j].item[0])) continue;
							var cur = this.items[j][this.containers[i].floating ? 'left' : 'top'];
							if(Math.abs(cur - base) < dist) {
								dist = Math.abs(cur - base); itemWithLeastDistance = this.items[j];
							}
						}

						if(!itemWithLeastDistance && !this.options.dropOnEmpty) //Check if dropOnEmpty is enabled
							continue;

						this.currentContainer = this.containers[i];
						itemWithLeastDistance ? this._rearrange(event, itemWithLeastDistance, null, true) : this._rearrange(event, null, this.containers[i].element, true);
						this._trigger("change", event, this._uiHash());
						this.containers[i]._trigger("change", event, this._uiHash(this));

						this.options.placeholder.update(this.currentContainer, this.placeholder);

					}

					this.containers[i]._trigger("over", event, this._uiHash(this));
					this.containers[i].containerCache.over = 1;
				}
			} else {
				if(this.containers[i].containerCache.over) {
					this.containers[i]._trigger("out", event, this._uiHash(this));
					this.containers[i].containerCache.over = 0;
				}
			}

		};
	},

	_createHelper: function(event) {

		var o = this.options;
		var helper = $.isFunction(o.helper) ? $(o.helper.apply(this.element[0], [event, this.currentItem])) : (o.helper == 'clone' ? this.currentItem.clone() : this.currentItem);

		if(!helper.parents('body').length) //Add the helper to the DOM if that didn't happen already
			$(o.appendTo != 'parent' ? o.appendTo : this.currentItem[0].parentNode)[0].appendChild(helper[0]);

		if(helper[0] == this.currentItem[0])
			this._storedCSS = { width: this.currentItem[0].style.width, height: this.currentItem[0].style.height, position: this.currentItem.css("position"), top: this.currentItem.css("top"), left: this.currentItem.css("left") };

		if(helper[0].style.width == '' || o.forceHelperSize) helper.width(this.currentItem.width());
		if(helper[0].style.height == '' || o.forceHelperSize) helper.height(this.currentItem.height());

		return helper;

	},

	_adjustOffsetFromHelper: function(obj) {
		if(obj.left != undefined) this.offset.click.left = obj.left + this.margins.left;
		if(obj.right != undefined) this.offset.click.left = this.helperProportions.width - obj.right + this.margins.left;
		if(obj.top != undefined) this.offset.click.top = obj.top + this.margins.top;
		if(obj.bottom != undefined) this.offset.click.top = this.helperProportions.height - obj.bottom + this.margins.top;
	},

	_getParentOffset: function() {


		this.offsetParent = this.helper.offsetParent();
		var po = this.offsetParent.offset();

		if(this.cssPosition == 'absolute' && this.scrollParent[0] != document && $.ui.contains(this.scrollParent[0], this.offsetParent[0])) {
			po.left += this.scrollParent.scrollLeft();
			po.top += this.scrollParent.scrollTop();
		}

		if((this.offsetParent[0] == document.body) //This needs to be actually done for all browsers, since pageX/pageY includes this information
		|| (this.offsetParent[0].tagName && this.offsetParent[0].tagName.toLowerCase() == 'html' && $.browser.msie)) //Ugly IE fix
			po = { top: 0, left: 0 };

		return {
			top: po.top + (parseInt(this.offsetParent.css("borderTopWidth"),10) || 0),
			left: po.left + (parseInt(this.offsetParent.css("borderLeftWidth"),10) || 0)
		};

	},

	_getRelativeOffset: function() {

		if(this.cssPosition == "relative") {
			var p = this.currentItem.position();
			return {
				top: p.top - (parseInt(this.helper.css("top"),10) || 0) + this.scrollParent.scrollTop(),
				left: p.left - (parseInt(this.helper.css("left"),10) || 0) + this.scrollParent.scrollLeft()
			};
		} else {
			return { top: 0, left: 0 };
		}

	},

	_cacheMargins: function() {
		this.margins = {
			left: (parseInt(this.currentItem.css("marginLeft"),10) || 0),
			top: (parseInt(this.currentItem.css("marginTop"),10) || 0)
		};
	},

	_cacheHelperProportions: function() {
		this.helperProportions = {
			width: this.helper.outerWidth(),
			height: this.helper.outerHeight()
		};
	},

	_setContainment: function() {

		var o = this.options;
		if(o.containment == 'parent') o.containment = this.helper[0].parentNode;
		if(o.containment == 'document' || o.containment == 'window') this.containment = [
			0 - this.offset.relative.left - this.offset.parent.left,
			0 - this.offset.relative.top - this.offset.parent.top,
			$(o.containment == 'document' ? document : window).width() - this.helperProportions.width - this.margins.left,
			($(o.containment == 'document' ? document : window).height() || document.body.parentNode.scrollHeight) - this.helperProportions.height - this.margins.top
		];

		if(!(/^(document|window|parent)$/).test(o.containment)) {
			var ce = $(o.containment)[0];
			var co = $(o.containment).offset();
			var over = ($(ce).css("overflow") != 'hidden');

			this.containment = [
				co.left + (parseInt($(ce).css("borderLeftWidth"),10) || 0) + (parseInt($(ce).css("paddingLeft"),10) || 0) - this.margins.left,
				co.top + (parseInt($(ce).css("borderTopWidth"),10) || 0) + (parseInt($(ce).css("paddingTop"),10) || 0) - this.margins.top,
				co.left+(over ? Math.max(ce.scrollWidth,ce.offsetWidth) : ce.offsetWidth) - (parseInt($(ce).css("borderLeftWidth"),10) || 0) - (parseInt($(ce).css("paddingRight"),10) || 0) - this.helperProportions.width - this.margins.left,
				co.top+(over ? Math.max(ce.scrollHeight,ce.offsetHeight) : ce.offsetHeight) - (parseInt($(ce).css("borderTopWidth"),10) || 0) - (parseInt($(ce).css("paddingBottom"),10) || 0) - this.helperProportions.height - this.margins.top
			];
		}

	},

	_convertPositionTo: function(d, pos) {

		if(!pos) pos = this.position;
		var mod = d == "absolute" ? 1 : -1;
		var o = this.options, scroll = this.cssPosition == 'absolute' && !(this.scrollParent[0] != document && $.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = (/(html|body)/i).test(scroll[0].tagName);

		return {
			top: (
				pos.top																	// The absolute mouse position
				+ this.offset.relative.top * mod										// Only for relative positioned nodes: Relative offset from element to offset parent
				+ this.offset.parent.top * mod											// The offsetParent's offset without borders (offset + border)
				- ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollTop() : ( scrollIsRootNode ? 0 : scroll.scrollTop() ) ) * mod)
			),
			left: (
				pos.left																// The absolute mouse position
				+ this.offset.relative.left * mod										// Only for relative positioned nodes: Relative offset from element to offset parent
				+ this.offset.parent.left * mod											// The offsetParent's offset without borders (offset + border)
				- ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft() ) * mod)
			)
		};

	},

	_generatePosition: function(event) {

		var o = this.options, scroll = this.cssPosition == 'absolute' && !(this.scrollParent[0] != document && $.ui.contains(this.scrollParent[0], this.offsetParent[0])) ? this.offsetParent : this.scrollParent, scrollIsRootNode = (/(html|body)/i).test(scroll[0].tagName);

		if(this.cssPosition == 'relative' && !(this.scrollParent[0] != document && this.scrollParent[0] != this.offsetParent[0])) {
			this.offset.relative = this._getRelativeOffset();
		}

		var pageX = event.pageX;
		var pageY = event.pageY;

		/*
		 * - Position constraining -
		 * Constrain the position to a mix of grid, containment.
		 */

		if(this.originalPosition) { //If we are not dragging yet, we won't check for options

			if(this.containment) {
				if(event.pageX - this.offset.click.left < this.containment[0]) pageX = this.containment[0] + this.offset.click.left;
				if(event.pageY - this.offset.click.top < this.containment[1]) pageY = this.containment[1] + this.offset.click.top;
				if(event.pageX - this.offset.click.left > this.containment[2]) pageX = this.containment[2] + this.offset.click.left;
				if(event.pageY - this.offset.click.top > this.containment[3]) pageY = this.containment[3] + this.offset.click.top;
			}

			if(o.grid) {
				var top = this.originalPageY + Math.round((pageY - this.originalPageY) / o.grid[1]) * o.grid[1];
				pageY = this.containment ? (!(top - this.offset.click.top < this.containment[1] || top - this.offset.click.top > this.containment[3]) ? top : (!(top - this.offset.click.top < this.containment[1]) ? top - o.grid[1] : top + o.grid[1])) : top;

				var left = this.originalPageX + Math.round((pageX - this.originalPageX) / o.grid[0]) * o.grid[0];
				pageX = this.containment ? (!(left - this.offset.click.left < this.containment[0] || left - this.offset.click.left > this.containment[2]) ? left : (!(left - this.offset.click.left < this.containment[0]) ? left - o.grid[0] : left + o.grid[0])) : left;
			}

		}

		return {
			top: (
				pageY																// The absolute mouse position
				- this.offset.click.top													// Click offset (relative to the element)
				- this.offset.relative.top												// Only for relative positioned nodes: Relative offset from element to offset parent
				- this.offset.parent.top												// The offsetParent's offset without borders (offset + border)
				+ ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollTop() : ( scrollIsRootNode ? 0 : scroll.scrollTop() ) ))
			),
			left: (
				pageX																// The absolute mouse position
				- this.offset.click.left												// Click offset (relative to the element)
				- this.offset.relative.left												// Only for relative positioned nodes: Relative offset from element to offset parent
				- this.offset.parent.left												// The offsetParent's offset without borders (offset + border)
				+ ($.browser.safari && this.cssPosition == 'fixed' ? 0 : ( this.cssPosition == 'fixed' ? -this.scrollParent.scrollLeft() : scrollIsRootNode ? 0 : scroll.scrollLeft() ))
			)
		};

	},

	_rearrange: function(event, i, a, hardRefresh) {

		a ? a[0].appendChild(this.placeholder[0]) : i.item[0].parentNode.insertBefore(this.placeholder[0], (this.direction == 'down' ? i.item[0] : i.item[0].nextSibling));

		this.counter = this.counter ? ++this.counter : 1;
		var self = this, counter = this.counter;

		window.setTimeout(function() {
			if(counter == self.counter) self.refreshPositions(!hardRefresh); //Precompute after each DOM insertion, NOT on mousemove
		},0);

	},

	_clear: function(event, noPropagation) {

		this.reverting = false;
		var delayedTriggers = [], self = this;

		if(!this._noFinalSort && this.currentItem[0].parentNode) this.placeholder.before(this.currentItem);
		this._noFinalSort = null;

		if(this.helper[0] == this.currentItem[0]) {
			for(var i in this._storedCSS) {
				if(this._storedCSS[i] == 'auto' || this._storedCSS[i] == 'static') this._storedCSS[i] = '';
			}
			this.currentItem.css(this._storedCSS).removeClass("ui-sortable-helper");
		} else {
			this.currentItem.show();
		}

		if(this.fromOutside && !noPropagation) delayedTriggers.push(function(event) { this._trigger("receive", event, this._uiHash(this.fromOutside)); });
		if((this.fromOutside || this.domPosition.prev != this.currentItem.prev().not(".ui-sortable-helper")[0] || this.domPosition.parent != this.currentItem.parent()[0]) && !noPropagation) delayedTriggers.push(function(event) { this._trigger("update", event, this._uiHash()); }); //Trigger update callback if the DOM position has changed
		if(!$.ui.contains(this.element[0], this.currentItem[0])) { //Node was moved out of the current element
			if(!noPropagation) delayedTriggers.push(function(event) { this._trigger("remove", event, this._uiHash()); });
			for (var i = this.containers.length - 1; i >= 0; i--){
				if($.ui.contains(this.containers[i].element[0], this.currentItem[0]) && !noPropagation) {
					delayedTriggers.push((function(c) { return function(event) { c._trigger("receive", event, this._uiHash(this)); };  }).call(this, this.containers[i]));
					delayedTriggers.push((function(c) { return function(event) { c._trigger("update", event, this._uiHash(this));  }; }).call(this, this.containers[i]));
				}
			};
		};

		for (var i = this.containers.length - 1; i >= 0; i--){
			if(!noPropagation) delayedTriggers.push((function(c) { return function(event) { c._trigger("deactivate", event, this._uiHash(this)); };  }).call(this, this.containers[i]));
			if(this.containers[i].containerCache.over) {
				delayedTriggers.push((function(c) { return function(event) { c._trigger("out", event, this._uiHash(this)); };  }).call(this, this.containers[i]));
				this.containers[i].containerCache.over = 0;
			}
		}

		if(this._storedCursor) $('body').css("cursor", this._storedCursor); //Reset cursor
		if(this._storedOpacity) this.helper.css("opacity", this._storedOpacity); //Reset cursor
		if(this._storedZIndex) this.helper.css("zIndex", this._storedZIndex == 'auto' ? '' : this._storedZIndex); //Reset z-index

		this.dragging = false;
		if(this.cancelHelperRemoval) {
			if(!noPropagation) {
				this._trigger("beforeStop", event, this._uiHash());
				for (var i=0; i < delayedTriggers.length; i++) { delayedTriggers[i].call(this, event); }; //Trigger all delayed events
				this._trigger("stop", event, this._uiHash());
			}
			return false;
		}

		if(!noPropagation) this._trigger("beforeStop", event, this._uiHash());

		this.placeholder[0].parentNode.removeChild(this.placeholder[0]);

		if(this.helper[0] != this.currentItem[0]) this.helper.remove(); this.helper = null;

		if(!noPropagation) {
			for (var i=0; i < delayedTriggers.length; i++) { delayedTriggers[i].call(this, event); }; //Trigger all delayed events
			this._trigger("stop", event, this._uiHash());
		}

		this.fromOutside = false;
		return true;

	},

	_trigger: function() {
		if ($.widget.prototype._trigger.apply(this, arguments) === false) {
			this.cancel();
		}
	},

	_uiHash: function(inst) {
		var self = inst || this;
		return {
			helper: self.helper,
			placeholder: self.placeholder || $([]),
			position: self.position,
			absolutePosition: self.positionAbs, //deprecated
			offset: self.positionAbs,
			item: self.currentItem,
			sender: inst ? inst.element : null
		};
	}

}));

$.extend($.ui.sortable, {
	getter: "serialize toArray",
	version: "1.7.2",
	eventPrefix: "sort",
	defaults: {
		appendTo: "parent",
		axis: false,
		cancel: ":input,option",
		connectWith: false,
		containment: false,
		cursor: 'auto',
		cursorAt: false,
		delay: 0,
		distance: 1,
		dropOnEmpty: true,
		forcePlaceholderSize: false,
		forceHelperSize: false,
		grid: false,
		handle: false,
		helper: "original",
		items: '> *',
		opacity: false,
		placeholder: false,
		revert: false,
		scroll: true,
		scrollSensitivity: 20,
		scrollSpeed: 20,
		scope: "default",
		tolerance: "intersect",
		zIndex: 1000
	}
});

})(jQuery);
/*
 * jQuery UI Accordion 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Accordion
 *
 * Depends:
 *	ui.core.js
 */
(function($) {

$.widget("ui.accordion", {

	_init: function() {

		var o = this.options, self = this;
		this.running = 0;

		if (o.collapsible == $.ui.accordion.defaults.collapsible &&
			o.alwaysOpen != $.ui.accordion.defaults.alwaysOpen) {
			o.collapsible = !o.alwaysOpen;
		}

		if ( o.navigation ) {
			var current = this.element.find("a").filter(o.navigationFilter);
			if ( current.length ) {
				if ( current.filter(o.header).length ) {
					this.active = current;
				} else {
					this.active = current.parent().parent().prev();
					current.addClass("ui-accordion-content-active");
				}
			}
		}

		this.element.addClass("ui-accordion ui-widget ui-helper-reset");

		if (this.element[0].nodeName == "UL") {
			this.element.children("li").addClass("ui-accordion-li-fix");
		}

		this.headers = this.element.find(o.header).addClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-all")
			.bind("mouseenter.accordion", function(){ $(this).addClass('ui-state-hover'); })
			.bind("mouseleave.accordion", function(){ $(this).removeClass('ui-state-hover'); })
			.bind("focus.accordion", function(){ $(this).addClass('ui-state-focus'); })
			.bind("blur.accordion", function(){ $(this).removeClass('ui-state-focus'); });

		this.headers
			.next()
				.addClass("ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom");

		this.active = this._findActive(this.active || o.active).toggleClass("ui-state-default").toggleClass("ui-state-active").toggleClass("ui-corner-all").toggleClass("ui-corner-top");
		this.active.next().addClass('ui-accordion-content-active');

		$("<span/>").addClass("ui-icon " + o.icons.header).prependTo(this.headers);
		this.active.find(".ui-icon").toggleClass(o.icons.header).toggleClass(o.icons.headerSelected);

		if ($.browser.msie) {
			this.element.find('a').css('zoom', '1');
		}

		this.resize();

		this.element.attr('role','tablist');

		this.headers
			.attr('role','tab')
			.bind('keydown', function(event) { return self._keydown(event); })
			.next()
			.attr('role','tabpanel');

		this.headers
			.not(this.active || "")
			.attr('aria-expanded','false')
			.attr("tabIndex", "-1")
			.next()
			.hide();

		if (!this.active.length) {
			this.headers.eq(0).attr('tabIndex','0');
		} else {
			this.active
				.attr('aria-expanded','true')
				.attr('tabIndex', '0');
		}

		if (!$.browser.safari)
			this.headers.find('a').attr('tabIndex','-1');

		if (o.event) {
			this.headers.bind((o.event) + ".accordion", function(event) { return self._clickHandler.call(self, event, this); });
		}

	},

	destroy: function() {
		var o = this.options;

		this.element
			.removeClass("ui-accordion ui-widget ui-helper-reset")
			.removeAttr("role")
			.unbind('.accordion')
			.removeData('accordion');

		this.headers
			.unbind(".accordion")
			.removeClass("ui-accordion-header ui-helper-reset ui-state-default ui-corner-all ui-state-active ui-corner-top")
			.removeAttr("role").removeAttr("aria-expanded").removeAttr("tabindex");

		this.headers.find("a").removeAttr("tabindex");
		this.headers.children(".ui-icon").remove();
		var contents = this.headers.next().css("display", "").removeAttr("role").removeClass("ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content ui-accordion-content-active");
		if (o.autoHeight || o.fillHeight) {
			contents.css("height", "");
		}
	},

	_setData: function(key, value) {
		if(key == 'alwaysOpen') { key = 'collapsible'; value = !value; }
		$.widget.prototype._setData.apply(this, arguments);
	},

	_keydown: function(event) {

		var o = this.options, keyCode = $.ui.keyCode;

		if (o.disabled || event.altKey || event.ctrlKey)
			return;

		var length = this.headers.length;
		var currentIndex = this.headers.index(event.target);
		var toFocus = false;

		switch(event.keyCode) {
			case keyCode.RIGHT:
			case keyCode.DOWN:
				toFocus = this.headers[(currentIndex + 1) % length];
				break;
			case keyCode.LEFT:
			case keyCode.UP:
				toFocus = this.headers[(currentIndex - 1 + length) % length];
				break;
			case keyCode.SPACE:
			case keyCode.ENTER:
				return this._clickHandler({ target: event.target }, event.target);
		}

		if (toFocus) {
			$(event.target).attr('tabIndex','-1');
			$(toFocus).attr('tabIndex','0');
			toFocus.focus();
			return false;
		}

		return true;

	},

	resize: function() {

		var o = this.options, maxHeight;

		if (o.fillSpace) {

			if($.browser.msie) { var defOverflow = this.element.parent().css('overflow'); this.element.parent().css('overflow', 'hidden'); }
			maxHeight = this.element.parent().height();
			if($.browser.msie) { this.element.parent().css('overflow', defOverflow); }

			this.headers.each(function() {
				maxHeight -= $(this).outerHeight();
			});

			var maxPadding = 0;
			this.headers.next().each(function() {
				maxPadding = Math.max(maxPadding, $(this).innerHeight() - $(this).height());
			}).height(Math.max(0, maxHeight - maxPadding))
			.css('overflow', 'auto');

		} else if ( o.autoHeight ) {
			maxHeight = 0;
			this.headers.next().each(function() {
				maxHeight = Math.max(maxHeight, $(this).outerHeight());
			}).height(maxHeight);
		}

	},

	activate: function(index) {
		var active = this._findActive(index)[0];
		this._clickHandler({ target: active }, active);
	},

	_findActive: function(selector) {
		return selector
			? typeof selector == "number"
				? this.headers.filter(":eq(" + selector + ")")
				: this.headers.not(this.headers.not(selector))
			: selector === false
				? $([])
				: this.headers.filter(":eq(0)");
	},

	_clickHandler: function(event, target) {

		var o = this.options;
		if (o.disabled) return false;

		if (!event.target && o.collapsible) {
			this.active.removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all")
				.find(".ui-icon").removeClass(o.icons.headerSelected).addClass(o.icons.header);
			this.active.next().addClass('ui-accordion-content-active');
			var toHide = this.active.next(),
				data = {
					options: o,
					newHeader: $([]),
					oldHeader: o.active,
					newContent: $([]),
					oldContent: toHide
				},
				toShow = (this.active = $([]));
			this._toggle(toShow, toHide, data);
			return false;
		}

		var clicked = $(event.currentTarget || target);
		var clickedIsActive = clicked[0] == this.active[0];

		if (this.running || (!o.collapsible && clickedIsActive)) {
			return false;
		}

		this.active.removeClass("ui-state-active ui-corner-top").addClass("ui-state-default ui-corner-all")
			.find(".ui-icon").removeClass(o.icons.headerSelected).addClass(o.icons.header);
		this.active.next().addClass('ui-accordion-content-active');
		if (!clickedIsActive) {
			clicked.removeClass("ui-state-default ui-corner-all").addClass("ui-state-active ui-corner-top")
				.find(".ui-icon").removeClass(o.icons.header).addClass(o.icons.headerSelected);
			clicked.next().addClass('ui-accordion-content-active');
		}

		var toShow = clicked.next(),
			toHide = this.active.next(),
			data = {
				options: o,
				newHeader: clickedIsActive && o.collapsible ? $([]) : clicked,
				oldHeader: this.active,
				newContent: clickedIsActive && o.collapsible ? $([]) : toShow.find('> *'),
				oldContent: toHide.find('> *')
			},
			down = this.headers.index( this.active[0] ) > this.headers.index( clicked[0] );

		this.active = clickedIsActive ? $([]) : clicked;
		this._toggle(toShow, toHide, data, clickedIsActive, down);

		return false;

	},

	_toggle: function(toShow, toHide, data, clickedIsActive, down) {

		var o = this.options, self = this;

		this.toShow = toShow;
		this.toHide = toHide;
		this.data = data;

		var complete = function() { if(!self) return; return self._completed.apply(self, arguments); };

		this._trigger("changestart", null, this.data);

		this.running = toHide.size() === 0 ? toShow.size() : toHide.size();

		if (o.animated) {

			var animOptions = {};

			if ( o.collapsible && clickedIsActive ) {
				animOptions = {
					toShow: $([]),
					toHide: toHide,
					complete: complete,
					down: down,
					autoHeight: o.autoHeight || o.fillSpace
				};
			} else {
				animOptions = {
					toShow: toShow,
					toHide: toHide,
					complete: complete,
					down: down,
					autoHeight: o.autoHeight || o.fillSpace
				};
			}

			if (!o.proxied) {
				o.proxied = o.animated;
			}

			if (!o.proxiedDuration) {
				o.proxiedDuration = o.duration;
			}

			o.animated = $.isFunction(o.proxied) ?
				o.proxied(animOptions) : o.proxied;

			o.duration = $.isFunction(o.proxiedDuration) ?
				o.proxiedDuration(animOptions) : o.proxiedDuration;

			var animations = $.ui.accordion.animations,
				duration = o.duration,
				easing = o.animated;

			if (!animations[easing]) {
				animations[easing] = function(options) {
					this.slide(options, {
						easing: easing,
						duration: duration || 700
					});
				};
			}

			animations[easing](animOptions);

		} else {

			if (o.collapsible && clickedIsActive) {
				toShow.toggle();
			} else {
				toHide.hide();
				toShow.show();
			}

			complete(true);

		}

		toHide.prev().attr('aria-expanded','false').attr("tabIndex", "-1").blur();
		toShow.prev().attr('aria-expanded','true').attr("tabIndex", "0").focus();

	},

	_completed: function(cancel) {

		var o = this.options;

		this.running = cancel ? 0 : --this.running;
		if (this.running) return;

		if (o.clearStyle) {
			this.toShow.add(this.toHide).css({
				height: "",
				overflow: ""
			});
		}

		this._trigger('change', null, this.data);
	}

});


$.extend($.ui.accordion, {
	version: "1.7.2",
	defaults: {
		active: null,
		alwaysOpen: true, //deprecated, use collapsible
		animated: 'slide',
		autoHeight: true,
		clearStyle: false,
		collapsible: false,
		event: "click",
		fillSpace: false,
		header: "> li > :first-child,> :not(li):even",
		icons: {
			header: "ui-icon-triangle-1-e",
			headerSelected: "ui-icon-triangle-1-s"
		},
		navigation: false,
		navigationFilter: function() {
			return this.href.toLowerCase() == location.href.toLowerCase();
		}
	},
	animations: {
		slide: function(options, additions) {
			options = $.extend({
				easing: "swing",
				duration: 300
			}, options, additions);
			if ( !options.toHide.size() ) {
				options.toShow.animate({height: "show"}, options);
				return;
			}
			if ( !options.toShow.size() ) {
				options.toHide.animate({height: "hide"}, options);
				return;
			}
			var overflow = options.toShow.css('overflow'),
				percentDone,
				showProps = {},
				hideProps = {},
				fxAttrs = [ "height", "paddingTop", "paddingBottom" ],
				originalWidth;
			var s = options.toShow;
			originalWidth = s[0].style.width;
			s.width( parseInt(s.parent().width(),10) - parseInt(s.css("paddingLeft"),10) - parseInt(s.css("paddingRight"),10) - (parseInt(s.css("borderLeftWidth"),10) || 0) - (parseInt(s.css("borderRightWidth"),10) || 0) );

			$.each(fxAttrs, function(i, prop) {
				hideProps[prop] = 'hide';

				var parts = ('' + $.css(options.toShow[0], prop)).match(/^([\d+-.]+)(.*)$/);
				showProps[prop] = {
					value: parts[1],
					unit: parts[2] || 'px'
				};
			});
			options.toShow.css({ height: 0, overflow: 'hidden' }).show();
			options.toHide.filter(":hidden").each(options.complete).end().filter(":visible").animate(hideProps,{
				step: function(now, settings) {
					if (settings.prop == 'height') {
						percentDone = (settings.now - settings.start) / (settings.end - settings.start);
					}

					options.toShow[0].style[settings.prop] =
						(percentDone * showProps[settings.prop].value) + showProps[settings.prop].unit;
				},
				duration: options.duration,
				easing: options.easing,
				complete: function() {
					if ( !options.autoHeight ) {
						options.toShow.css("height", "");
					}
					options.toShow.css("width", originalWidth);
					options.toShow.css({overflow: overflow});
					options.complete();
				}
			});
		},
		bounceslide: function(options) {
			this.slide(options, {
				easing: options.down ? "easeOutBounce" : "swing",
				duration: options.down ? 1000 : 200
			});
		},
		easeslide: function(options) {
			this.slide(options, {
				easing: "easeinout",
				duration: 700
			});
		}
	}
});

})(jQuery);
/*
 * jQuery UI Dialog 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Dialog
 *
 * Depends:
 *	ui.core.js
 *	ui.draggable.js
 *	ui.resizable.js
 */
(function($) {

var setDataSwitch = {
		dragStart: "start.draggable",
		drag: "drag.draggable",
		dragStop: "stop.draggable",
		maxHeight: "maxHeight.resizable",
		minHeight: "minHeight.resizable",
		maxWidth: "maxWidth.resizable",
		minWidth: "minWidth.resizable",
		resizeStart: "start.resizable",
		resize: "drag.resizable",
		resizeStop: "stop.resizable"
	},

	uiDialogClasses =
		'ui-dialog ' +
		'ui-widget ' +
		'ui-widget-content ' +
		'ui-corner-all ';

$.widget("ui.dialog", {

	_init: function() {
		this.originalTitle = this.element.attr('title');

		var self = this,
			options = this.options,

			title = options.title || this.originalTitle || '&nbsp;',
			titleId = $.ui.dialog.getTitleId(this.element),

			uiDialog = (this.uiDialog = $('<div/>'))
				.appendTo(document.body)
				.hide()
				.addClass(uiDialogClasses + options.dialogClass)
				.css({
					position: 'absolute',
					overflow: 'hidden',
					zIndex: options.zIndex
				})
				.attr('tabIndex', -1).css('outline', 0).keydown(function(event) {
					(options.closeOnEscape && event.keyCode
						&& event.keyCode == $.ui.keyCode.ESCAPE && self.close(event));
				})
				.attr({
					role: 'dialog',
					'aria-labelledby': titleId
				})
				.mousedown(function(event) {
					self.moveToTop(false, event);
				}),

			uiDialogContent = this.element
				.show()
				.removeAttr('title')
				.addClass(
					'ui-dialog-content ' +
					'ui-widget-content')
				.appendTo(uiDialog),

			uiDialogTitlebar = (this.uiDialogTitlebar = $('<div></div>'))
				.addClass(
					'ui-dialog-titlebar ' +
					'ui-widget-header ' +
					'ui-corner-all ' +
					'ui-helper-clearfix'
				)
				.prependTo(uiDialog),

			uiDialogTitlebarClose = $('<a href="#"/>')
				.addClass(
					'ui-dialog-titlebar-close ' +
					'ui-corner-all'
				)
				.attr('role', 'button')
				.hover(
					function() {
						uiDialogTitlebarClose.addClass('ui-state-hover');
					},
					function() {
						uiDialogTitlebarClose.removeClass('ui-state-hover');
					}
				)
				.focus(function() {
					uiDialogTitlebarClose.addClass('ui-state-focus');
				})
				.blur(function() {
					uiDialogTitlebarClose.removeClass('ui-state-focus');
				})
				.mousedown(function(ev) {
					ev.stopPropagation();
				})
				.click(function(event) {
					self.close(event);
					return false;
				})
				.appendTo(uiDialogTitlebar),

			uiDialogTitlebarCloseText = (this.uiDialogTitlebarCloseText = $('<span/>'))
				.addClass(
					'ui-icon ' +
					'ui-icon-closethick'
				)
				.text(options.closeText)
				.appendTo(uiDialogTitlebarClose),

			uiDialogTitle = $('<span/>')
				.addClass('ui-dialog-title')
				.attr('id', titleId)
				.html(title)
				.prependTo(uiDialogTitlebar);

		uiDialogTitlebar.find("*").add(uiDialogTitlebar).disableSelection();

		(options.draggable && $.fn.draggable && this._makeDraggable());
		(options.resizable && $.fn.resizable && this._makeResizable());

		this._createButtons(options.buttons);
		this._isOpen = false;

		(options.bgiframe && $.fn.bgiframe && uiDialog.bgiframe());
		(options.autoOpen && this.open());

	},

	destroy: function() {
		(this.overlay && this.overlay.destroy());
		this.uiDialog.hide();
		this.element
			.unbind('.dialog')
			.removeData('dialog')
			.removeClass('ui-dialog-content ui-widget-content')
			.hide().appendTo('body');
		this.uiDialog.remove();

		(this.originalTitle && this.element.attr('title', this.originalTitle));
	},

	close: function(event) {
		var self = this;

		if (false === self._trigger('beforeclose', event)) {
			return;
		}

		(self.overlay && self.overlay.destroy());
		self.uiDialog.unbind('keypress.ui-dialog');

		(self.options.hide
			? self.uiDialog.hide(self.options.hide, function() {
				self._trigger('close', event);
			})
			: self.uiDialog.hide() && self._trigger('close', event));

		$.ui.dialog.overlay.resize();

		self._isOpen = false;

		if (self.options.modal) {
			var maxZ = 0;
			$('.ui-dialog').each(function() {
				if (this != self.uiDialog[0]) {
					maxZ = Math.max(maxZ, $(this).css('z-index'));
				}
			});
			$.ui.dialog.maxZ = maxZ;
		}
	},

	isOpen: function() {
		return this._isOpen;
	},

	moveToTop: function(force, event) {

		if ((this.options.modal && !force)
			|| (!this.options.stack && !this.options.modal)) {
			return this._trigger('focus', event);
		}

		if (this.options.zIndex > $.ui.dialog.maxZ) {
			$.ui.dialog.maxZ = this.options.zIndex;
		}
		(this.overlay && this.overlay.$el.css('z-index', $.ui.dialog.overlay.maxZ = ++$.ui.dialog.maxZ));

		var saveScroll = { scrollTop: this.element.attr('scrollTop'), scrollLeft: this.element.attr('scrollLeft') };
		this.uiDialog.css('z-index', ++$.ui.dialog.maxZ);
		this.element.attr(saveScroll);
		this._trigger('focus', event);
	},

	open: function() {
		if (this._isOpen) { return; }

		var options = this.options,
			uiDialog = this.uiDialog;

		this.overlay = options.modal ? new $.ui.dialog.overlay(this) : null;
		(uiDialog.next().length && uiDialog.appendTo('body'));
		this._size();
		this._position(options.position);
		uiDialog.show(options.show);
		this.moveToTop(true);

		(options.modal && uiDialog.bind('keypress.ui-dialog', function(event) {
			if (event.keyCode != $.ui.keyCode.TAB) {
				return;
			}

			var tabbables = $(':tabbable', this),
				first = tabbables.filter(':first')[0],
				last  = tabbables.filter(':last')[0];

			if (event.target == last && !event.shiftKey) {
				setTimeout(function() {
					first.focus();
				}, 1);
			} else if (event.target == first && event.shiftKey) {
				setTimeout(function() {
					last.focus();
				}, 1);
			}
		}));

		$([])
			.add(uiDialog.find('.ui-dialog-content :tabbable:first'))
			.add(uiDialog.find('.ui-dialog-buttonpane :tabbable:first'))
			.add(uiDialog)
			.filter(':first')
			.focus();

		this._trigger('open');
		this._isOpen = true;
	},

	_createButtons: function(buttons) {
		var self = this,
			hasButtons = false,
			uiDialogButtonPane = $('<div></div>')
				.addClass(
					'ui-dialog-buttonpane ' +
					'ui-widget-content ' +
					'ui-helper-clearfix'
				);

		this.uiDialog.find('.ui-dialog-buttonpane').remove();

		(typeof buttons == 'object' && buttons !== null &&
			$.each(buttons, function() { return !(hasButtons = true); }));
		if (hasButtons) {
			$.each(buttons, function(name, fn) {
				$('<button type="button"></button>')
					.addClass(
						'ui-state-default ' +
						'ui-corner-all'
					)
					.text(name)
					.click(function() { fn.apply(self.element[0], arguments); })
					.hover(
						function() {
							$(this).addClass('ui-state-hover');
						},
						function() {
							$(this).removeClass('ui-state-hover');
						}
					)
					.focus(function() {
						$(this).addClass('ui-state-focus');
					})
					.blur(function() {
						$(this).removeClass('ui-state-focus');
					})
					.appendTo(uiDialogButtonPane);
			});
			uiDialogButtonPane.appendTo(this.uiDialog);
		}
	},

	_makeDraggable: function() {
		var self = this,
			options = this.options,
			heightBeforeDrag;

		this.uiDialog.draggable({
			cancel: '.ui-dialog-content',
			handle: '.ui-dialog-titlebar',
			containment: 'document',
			start: function() {
				heightBeforeDrag = options.height;
				$(this).height($(this).height()).addClass("ui-dialog-dragging");
				(options.dragStart && options.dragStart.apply(self.element[0], arguments));
			},
			drag: function() {
				(options.drag && options.drag.apply(self.element[0], arguments));
			},
			stop: function() {
				$(this).removeClass("ui-dialog-dragging").height(heightBeforeDrag);
				(options.dragStop && options.dragStop.apply(self.element[0], arguments));
				$.ui.dialog.overlay.resize();
			}
		});
	},

	_makeResizable: function(handles) {
		handles = (handles === undefined ? this.options.resizable : handles);
		var self = this,
			options = this.options,
			resizeHandles = typeof handles == 'string'
				? handles
				: 'n,e,s,w,se,sw,ne,nw';

		this.uiDialog.resizable({
			cancel: '.ui-dialog-content',
			alsoResize: this.element,
			maxWidth: options.maxWidth,
			maxHeight: options.maxHeight,
			minWidth: options.minWidth,
			minHeight: options.minHeight,
			start: function() {
				$(this).addClass("ui-dialog-resizing");
				(options.resizeStart && options.resizeStart.apply(self.element[0], arguments));
			},
			resize: function() {
				(options.resize && options.resize.apply(self.element[0], arguments));
			},
			handles: resizeHandles,
			stop: function() {
				$(this).removeClass("ui-dialog-resizing");
				options.height = $(this).height();
				options.width = $(this).width();
				(options.resizeStop && options.resizeStop.apply(self.element[0], arguments));
				$.ui.dialog.overlay.resize();
			}
		})
		.find('.ui-resizable-se').addClass('ui-icon ui-icon-grip-diagonal-se');
	},

	_position: function(pos) {
		var wnd = $(window), doc = $(document),
			pTop = doc.scrollTop(), pLeft = doc.scrollLeft(),
			minTop = pTop;

		if ($.inArray(pos, ['center','top','right','bottom','left']) >= 0) {
			pos = [
				pos == 'right' || pos == 'left' ? pos : 'center',
				pos == 'top' || pos == 'bottom' ? pos : 'middle'
			];
		}
		if (pos.constructor != Array) {
			pos = ['center', 'middle'];
		}
		if (pos[0].constructor == Number) {
			pLeft += pos[0];
		} else {
			switch (pos[0]) {
				case 'left':
					pLeft += 0;
					break;
				case 'right':
					pLeft += wnd.width() - this.uiDialog.outerWidth();
					break;
				default:
				case 'center':
					pLeft += (wnd.width() - this.uiDialog.outerWidth()) / 2;
			}
		}
		if (pos[1].constructor == Number) {
			pTop += pos[1];
		} else {
			switch (pos[1]) {
				case 'top':
					pTop += 0;
					break;
				case 'bottom':
					pTop += wnd.height() - this.uiDialog.outerHeight();
					break;
				default:
				case 'middle':
					pTop += (wnd.height() - this.uiDialog.outerHeight()) / 2;
			}
		}

		pTop = Math.max(pTop, minTop);
		this.uiDialog.css({top: pTop, left: pLeft});
	},

	_setData: function(key, value){
		(setDataSwitch[key] && this.uiDialog.data(setDataSwitch[key], value));
		switch (key) {
			case "buttons":
				this._createButtons(value);
				break;
			case "closeText":
				this.uiDialogTitlebarCloseText.text(value);
				break;
			case "dialogClass":
				this.uiDialog
					.removeClass(this.options.dialogClass)
					.addClass(uiDialogClasses + value);
				break;
			case "draggable":
				(value
					? this._makeDraggable()
					: this.uiDialog.draggable('destroy'));
				break;
			case "height":
				this.uiDialog.height(value);
				break;
			case "position":
				this._position(value);
				break;
			case "resizable":
				var uiDialog = this.uiDialog,
					isResizable = this.uiDialog.is(':data(resizable)');

				(isResizable && !value && uiDialog.resizable('destroy'));

				(isResizable && typeof value == 'string' &&
					uiDialog.resizable('option', 'handles', value));

				(isResizable || this._makeResizable(value));
				break;
			case "title":
				$(".ui-dialog-title", this.uiDialogTitlebar).html(value || '&nbsp;');
				break;
			case "width":
				this.uiDialog.width(value);
				break;
		}

		$.widget.prototype._setData.apply(this, arguments);
	},

	_size: function() {
		/* If the user has resized the dialog, the .ui-dialog and .ui-dialog-content
		 * divs will both have width and height set, so we need to reset them
		 */
		var options = this.options;

		this.element.css({
			height: 0,
			minHeight: 0,
			width: 'auto'
		});

		var nonContentHeight = this.uiDialog.css({
				height: 'auto',
				width: options.width
			})
			.height();

		this.element
			.css({
				minHeight: Math.max(options.minHeight - nonContentHeight, 0),
				height: options.height == 'auto'
					? 'auto'
					: Math.max(options.height - nonContentHeight, 0)
			});
	}
});

$.extend($.ui.dialog, {
	version: "1.7.2",
	defaults: {
		autoOpen: true,
		bgiframe: false,
		buttons: {},
		closeOnEscape: true,
		closeText: 'close',
		dialogClass: '',
		draggable: true,
		hide: null,
		height: 'auto',
		maxHeight: false,
		maxWidth: false,
		minHeight: 150,
		minWidth: 150,
		modal: false,
		position: 'center',
		resizable: true,
		show: null,
		stack: true,
		title: '',
		width: 300,
		zIndex: 1000
	},

	getter: 'isOpen',

	uuid: 0,
	maxZ: 0,

	getTitleId: function($el) {
		return 'ui-dialog-title-' + ($el.attr('id') || ++this.uuid);
	},

	overlay: function(dialog) {
		this.$el = $.ui.dialog.overlay.create(dialog);
	}
});

$.extend($.ui.dialog.overlay, {
	instances: [],
	maxZ: 0,
	events: $.map('focus,mousedown,mouseup,keydown,keypress,click'.split(','),
		function(event) { return event + '.dialog-overlay'; }).join(' '),
	create: function(dialog) {
		if (this.instances.length === 0) {
			setTimeout(function() {
				if ($.ui.dialog.overlay.instances.length) {
					$(document).bind($.ui.dialog.overlay.events, function(event) {
						var dialogZ = $(event.target).parents('.ui-dialog').css('zIndex') || 0;
						return (dialogZ > $.ui.dialog.overlay.maxZ);
					});
				}
			}, 1);

			$(document).bind('keydown.dialog-overlay', function(event) {
				(dialog.options.closeOnEscape && event.keyCode
						&& event.keyCode == $.ui.keyCode.ESCAPE && dialog.close(event));
			});

			$(window).bind('resize.dialog-overlay', $.ui.dialog.overlay.resize);
		}

		var $el = $('<div></div>').appendTo(document.body)
			.addClass('ui-widget-overlay').css({
				width: this.width(),
				height: this.height()
			});

		(dialog.options.bgiframe && $.fn.bgiframe && $el.bgiframe());

		this.instances.push($el);
		return $el;
	},

	destroy: function($el) {
		this.instances.splice($.inArray(this.instances, $el), 1);

		if (this.instances.length === 0) {
			$([document, window]).unbind('.dialog-overlay');
		}

		$el.remove();

		var maxZ = 0;
		$.each(this.instances, function() {
			maxZ = Math.max(maxZ, this.css('z-index'));
		});
		this.maxZ = maxZ;
	},

	height: function() {
		if ($.browser.msie && $.browser.version < 7) {
			var scrollHeight = Math.max(
				document.documentElement.scrollHeight,
				document.body.scrollHeight
			);
			var offsetHeight = Math.max(
				document.documentElement.offsetHeight,
				document.body.offsetHeight
			);

			if (scrollHeight < offsetHeight) {
				return $(window).height() + 'px';
			} else {
				return scrollHeight + 'px';
			}
		} else {
			return $(document).height() + 'px';
		}
	},

	width: function() {
		if ($.browser.msie && $.browser.version < 7) {
			var scrollWidth = Math.max(
				document.documentElement.scrollWidth,
				document.body.scrollWidth
			);
			var offsetWidth = Math.max(
				document.documentElement.offsetWidth,
				document.body.offsetWidth
			);

			if (scrollWidth < offsetWidth) {
				return $(window).width() + 'px';
			} else {
				return scrollWidth + 'px';
			}
		} else {
			return $(document).width() + 'px';
		}
	},

	resize: function() {
		/* If the dialog is draggable and the user drags it past the
		 * right edge of the window, the document becomes wider so we
		 * need to stretch the overlay. If the user then drags the
		 * dialog back to the left, the document will become narrower,
		 * so we need to shrink the overlay to the appropriate size.
		 * This is handled by shrinking the overlay before setting it
		 * to the full document size.
		 */
		var $overlays = $([]);
		$.each($.ui.dialog.overlay.instances, function() {
			$overlays = $overlays.add(this);
		});

		$overlays.css({
			width: 0,
			height: 0
		}).css({
			width: $.ui.dialog.overlay.width(),
			height: $.ui.dialog.overlay.height()
		});
	}
});

$.extend($.ui.dialog.overlay.prototype, {
	destroy: function() {
		$.ui.dialog.overlay.destroy(this.$el);
	}
});

})(jQuery);
/*
 * jQuery UI Slider 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Slider
 *
 * Depends:
 *	ui.core.js
 */

(function($) {

$.widget("ui.slider", $.extend({}, $.ui.mouse, {

	_init: function() {

		var self = this, o = this.options;
		this._keySliding = false;
		this._handleIndex = null;
		this._detectOrientation();
		this._mouseInit();

		this.element
			.addClass("ui-slider"
				+ " ui-slider-" + this.orientation
				+ " ui-widget"
				+ " ui-widget-content"
				+ " ui-corner-all");

		this.range = $([]);

		if (o.range) {

			if (o.range === true) {
				this.range = $('<div></div>');
				if (!o.values) o.values = [this._valueMin(), this._valueMin()];
				if (o.values.length && o.values.length != 2) {
					o.values = [o.values[0], o.values[0]];
				}
			} else {
				this.range = $('<div></div>');
			}

			this.range
				.appendTo(this.element)
				.addClass("ui-slider-range");

			if (o.range == "min" || o.range == "max") {
				this.range.addClass("ui-slider-range-" + o.range);
			}

			this.range.addClass("ui-widget-header");

		}

		if ($(".ui-slider-handle", this.element).length == 0)
			$('<a href="#"></a>')
				.appendTo(this.element)
				.addClass("ui-slider-handle");

		if (o.values && o.values.length) {
			while ($(".ui-slider-handle", this.element).length < o.values.length)
				$('<a href="#"></a>')
					.appendTo(this.element)
					.addClass("ui-slider-handle");
		}

		this.handles = $(".ui-slider-handle", this.element)
			.addClass("ui-state-default"
				+ " ui-corner-all");

		this.handle = this.handles.eq(0);

		this.handles.add(this.range).filter("a")
			.click(function(event) {
				event.preventDefault();
			})
			.hover(function() {
				if (!o.disabled) {
					$(this).addClass('ui-state-hover');
				}
			}, function() {
				$(this).removeClass('ui-state-hover');
			})
			.focus(function() {
				if (!o.disabled) {
					$(".ui-slider .ui-state-focus").removeClass('ui-state-focus'); $(this).addClass('ui-state-focus');
				} else {
					$(this).blur();
				}
			})
			.blur(function() {
				$(this).removeClass('ui-state-focus');
			});

		this.handles.each(function(i) {
			$(this).data("index.ui-slider-handle", i);
		});

		this.handles.keydown(function(event) {

			var ret = true;

			var index = $(this).data("index.ui-slider-handle");

			if (self.options.disabled)
				return;

			switch (event.keyCode) {
				case $.ui.keyCode.HOME:
				case $.ui.keyCode.END:
				case $.ui.keyCode.UP:
				case $.ui.keyCode.RIGHT:
				case $.ui.keyCode.DOWN:
				case $.ui.keyCode.LEFT:
					ret = false;
					if (!self._keySliding) {
						self._keySliding = true;
						$(this).addClass("ui-state-active");
						self._start(event, index);
					}
					break;
			}

			var curVal, newVal, step = self._step();
			if (self.options.values && self.options.values.length) {
				curVal = newVal = self.values(index);
			} else {
				curVal = newVal = self.value();
			}

			switch (event.keyCode) {
				case $.ui.keyCode.HOME:
					newVal = self._valueMin();
					break;
				case $.ui.keyCode.END:
					newVal = self._valueMax();
					break;
				case $.ui.keyCode.UP:
				case $.ui.keyCode.RIGHT:
					if(curVal == self._valueMax()) return;
					newVal = curVal + step;
					break;
				case $.ui.keyCode.DOWN:
				case $.ui.keyCode.LEFT:
					if(curVal == self._valueMin()) return;
					newVal = curVal - step;
					break;
			}

			self._slide(event, index, newVal);

			return ret;

		}).keyup(function(event) {

			var index = $(this).data("index.ui-slider-handle");

			if (self._keySliding) {
				self._stop(event, index);
				self._change(event, index);
				self._keySliding = false;
				$(this).removeClass("ui-state-active");
			}

		});

		this._refreshValue();

	},

	destroy: function() {

		this.handles.remove();
		this.range.remove();

		this.element
			.removeClass("ui-slider"
				+ " ui-slider-horizontal"
				+ " ui-slider-vertical"
				+ " ui-slider-disabled"
				+ " ui-widget"
				+ " ui-widget-content"
				+ " ui-corner-all")
			.removeData("slider")
			.unbind(".slider");

		this._mouseDestroy();

	},

	_mouseCapture: function(event) {

		var o = this.options;

		if (o.disabled)
			return false;

		this.elementSize = {
			width: this.element.outerWidth(),
			height: this.element.outerHeight()
		};
		this.elementOffset = this.element.offset();

		var position = { x: event.pageX, y: event.pageY };
		var normValue = this._normValueFromMouse(position);

		var distance = this._valueMax() - this._valueMin() + 1, closestHandle;
		var self = this, index;
		this.handles.each(function(i) {
			var thisDistance = Math.abs(normValue - self.values(i));
			if (distance > thisDistance) {
				distance = thisDistance;
				closestHandle = $(this);
				index = i;
			}
		});

		if(o.range == true && this.values(1) == o.min) {
			closestHandle = $(this.handles[++index]);
		}

		this._start(event, index);

		self._handleIndex = index;

		closestHandle
			.addClass("ui-state-active")
			.focus();

		var offset = closestHandle.offset();
		var mouseOverHandle = !$(event.target).parents().andSelf().is('.ui-slider-handle');
		this._clickOffset = mouseOverHandle ? { left: 0, top: 0 } : {
			left: event.pageX - offset.left - (closestHandle.width() / 2),
			top: event.pageY - offset.top
				- (closestHandle.height() / 2)
				- (parseInt(closestHandle.css('borderTopWidth'),10) || 0)
				- (parseInt(closestHandle.css('borderBottomWidth'),10) || 0)
				+ (parseInt(closestHandle.css('marginTop'),10) || 0)
		};

		normValue = this._normValueFromMouse(position);
		this._slide(event, index, normValue);
		return true;

	},

	_mouseStart: function(event) {
		return true;
	},

	_mouseDrag: function(event) {

		var position = { x: event.pageX, y: event.pageY };
		var normValue = this._normValueFromMouse(position);

		this._slide(event, this._handleIndex, normValue);

		return false;

	},

	_mouseStop: function(event) {

		this.handles.removeClass("ui-state-active");
		this._stop(event, this._handleIndex);
		this._change(event, this._handleIndex);
		this._handleIndex = null;
		this._clickOffset = null;

		return false;

	},

	_detectOrientation: function() {
		this.orientation = this.options.orientation == 'vertical' ? 'vertical' : 'horizontal';
	},

	_normValueFromMouse: function(position) {

		var pixelTotal, pixelMouse;
		if ('horizontal' == this.orientation) {
			pixelTotal = this.elementSize.width;
			pixelMouse = position.x - this.elementOffset.left - (this._clickOffset ? this._clickOffset.left : 0);
		} else {
			pixelTotal = this.elementSize.height;
			pixelMouse = position.y - this.elementOffset.top - (this._clickOffset ? this._clickOffset.top : 0);
		}

		var percentMouse = (pixelMouse / pixelTotal);
		if (percentMouse > 1) percentMouse = 1;
		if (percentMouse < 0) percentMouse = 0;
		if ('vertical' == this.orientation)
			percentMouse = 1 - percentMouse;

		var valueTotal = this._valueMax() - this._valueMin(),
			valueMouse = percentMouse * valueTotal,
			valueMouseModStep = valueMouse % this.options.step,
			normValue = this._valueMin() + valueMouse - valueMouseModStep;

		if (valueMouseModStep > (this.options.step / 2))
			normValue += this.options.step;

		return parseFloat(normValue.toFixed(5));

	},

	_start: function(event, index) {
		var uiHash = {
			handle: this.handles[index],
			value: this.value()
		};
		if (this.options.values && this.options.values.length) {
			uiHash.value = this.values(index);
			uiHash.values = this.values();
		}
		this._trigger("start", event, uiHash);
	},

	_slide: function(event, index, newVal) {

		var handle = this.handles[index];

		if (this.options.values && this.options.values.length) {

			var otherVal = this.values(index ? 0 : 1);

			if ((this.options.values.length == 2 && this.options.range === true) &&
				((index == 0 && newVal > otherVal) || (index == 1 && newVal < otherVal))){
 				newVal = otherVal;
			}

			if (newVal != this.values(index)) {
				var newValues = this.values();
				newValues[index] = newVal;
				var allowed = this._trigger("slide", event, {
					handle: this.handles[index],
					value: newVal,
					values: newValues
				});
				var otherVal = this.values(index ? 0 : 1);
				if (allowed !== false) {
					this.values(index, newVal, ( event.type == 'mousedown' && this.options.animate ), true);
				}
			}

		} else {

			if (newVal != this.value()) {
				var allowed = this._trigger("slide", event, {
					handle: this.handles[index],
					value: newVal
				});
				if (allowed !== false) {
					this._setData('value', newVal, ( event.type == 'mousedown' && this.options.animate ));
				}

			}

		}

	},

	_stop: function(event, index) {
		var uiHash = {
			handle: this.handles[index],
			value: this.value()
		};
		if (this.options.values && this.options.values.length) {
			uiHash.value = this.values(index);
			uiHash.values = this.values();
		}
		this._trigger("stop", event, uiHash);
	},

	_change: function(event, index) {
		var uiHash = {
			handle: this.handles[index],
			value: this.value()
		};
		if (this.options.values && this.options.values.length) {
			uiHash.value = this.values(index);
			uiHash.values = this.values();
		}
		this._trigger("change", event, uiHash);
	},

	value: function(newValue) {

		if (arguments.length) {
			this._setData("value", newValue);
			this._change(null, 0);
		}

		return this._value();

	},

	values: function(index, newValue, animated, noPropagation) {

		if (arguments.length > 1) {
			this.options.values[index] = newValue;
			this._refreshValue(animated);
			if(!noPropagation) this._change(null, index);
		}

		if (arguments.length) {
			if (this.options.values && this.options.values.length) {
				return this._values(index);
			} else {
				return this.value();
			}
		} else {
			return this._values();
		}

	},

	_setData: function(key, value, animated) {

		$.widget.prototype._setData.apply(this, arguments);

		switch (key) {
			case 'disabled':
				if (value) {
					this.handles.filter(".ui-state-focus").blur();
					this.handles.removeClass("ui-state-hover");
					this.handles.attr("disabled", "disabled");
				} else {
					this.handles.removeAttr("disabled");
				}
			case 'orientation':

				this._detectOrientation();

				this.element
					.removeClass("ui-slider-horizontal ui-slider-vertical")
					.addClass("ui-slider-" + this.orientation);
				this._refreshValue(animated);
				break;
			case 'value':
				this._refreshValue(animated);
				break;
		}

	},

	_step: function() {
		var step = this.options.step;
		return step;
	},

	_value: function() {

		var val = this.options.value;
		if (val < this._valueMin()) val = this._valueMin();
		if (val > this._valueMax()) val = this._valueMax();

		return val;

	},

	_values: function(index) {

		if (arguments.length) {
			var val = this.options.values[index];
			if (val < this._valueMin()) val = this._valueMin();
			if (val > this._valueMax()) val = this._valueMax();

			return val;
		} else {
			return this.options.values;
		}

	},

	_valueMin: function() {
		var valueMin = this.options.min;
		return valueMin;
	},

	_valueMax: function() {
		var valueMax = this.options.max;
		return valueMax;
	},

	_refreshValue: function(animate) {

		var oRange = this.options.range, o = this.options, self = this;

		if (this.options.values && this.options.values.length) {
			var vp0, vp1;
			this.handles.each(function(i, j) {
				var valPercent = (self.values(i) - self._valueMin()) / (self._valueMax() - self._valueMin()) * 100;
				var _set = {}; _set[self.orientation == 'horizontal' ? 'left' : 'bottom'] = valPercent + '%';
				$(this).stop(1,1)[animate ? 'animate' : 'css'](_set, o.animate);
				if (self.options.range === true) {
					if (self.orientation == 'horizontal') {
						(i == 0) && self.range.stop(1,1)[animate ? 'animate' : 'css']({ left: valPercent + '%' }, o.animate);
						(i == 1) && self.range[animate ? 'animate' : 'css']({ width: (valPercent - lastValPercent) + '%' }, { queue: false, duration: o.animate });
					} else {
						(i == 0) && self.range.stop(1,1)[animate ? 'animate' : 'css']({ bottom: (valPercent) + '%' }, o.animate);
						(i == 1) && self.range[animate ? 'animate' : 'css']({ height: (valPercent - lastValPercent) + '%' }, { queue: false, duration: o.animate });
					}
				}
				lastValPercent = valPercent;
			});
		} else {
			var value = this.value(),
				valueMin = this._valueMin(),
				valueMax = this._valueMax(),
				valPercent = valueMax != valueMin
					? (value - valueMin) / (valueMax - valueMin) * 100
					: 0;
			var _set = {}; _set[self.orientation == 'horizontal' ? 'left' : 'bottom'] = valPercent + '%';
			this.handle.stop(1,1)[animate ? 'animate' : 'css'](_set, o.animate);

			(oRange == "min") && (this.orientation == "horizontal") && this.range.stop(1,1)[animate ? 'animate' : 'css']({ width: valPercent + '%' }, o.animate);
			(oRange == "max") && (this.orientation == "horizontal") && this.range[animate ? 'animate' : 'css']({ width: (100 - valPercent) + '%' }, { queue: false, duration: o.animate });
			(oRange == "min") && (this.orientation == "vertical") && this.range.stop(1,1)[animate ? 'animate' : 'css']({ height: valPercent + '%' }, o.animate);
			(oRange == "max") && (this.orientation == "vertical") && this.range[animate ? 'animate' : 'css']({ height: (100 - valPercent) + '%' }, { queue: false, duration: o.animate });
		}

	}

}));

$.extend($.ui.slider, {
	getter: "value values",
	version: "1.7.2",
	eventPrefix: "slide",
	defaults: {
		animate: false,
		delay: 0,
		distance: 0,
		max: 100,
		min: 0,
		orientation: 'horizontal',
		range: false,
		step: 1,
		value: 0,
		values: null
	}
});

})(jQuery);
/*
 * jQuery UI Tabs 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Tabs
 *
 * Depends:
 *	ui.core.js
 */
(function($) {

$.widget("ui.tabs", {

	_init: function() {
		if (this.options.deselectable !== undefined) {
			this.options.collapsible = this.options.deselectable;
		}
		this._tabify(true);
	},

	_setData: function(key, value) {
		if (key == 'selected') {
			if (this.options.collapsible && value == this.options.selected) {
				return;
			}
			this.select(value);
		}
		else {
			this.options[key] = value;
			if (key == 'deselectable') {
				this.options.collapsible = value;
			}
			this._tabify();
		}
	},

	_tabId: function(a) {
		return a.title && a.title.replace(/\s/g, '_').replace(/[^A-Za-z0-9\-_:\.]/g, '') ||
			this.options.idPrefix + $.data(a);
	},

	_sanitizeSelector: function(hash) {
		return hash.replace(/:/g, '\\:'); // we need this because an id may contain a ":"
	},

	_cookie: function() {
		var cookie = this.cookie || (this.cookie = this.options.cookie.name || 'ui-tabs-' + $.data(this.list[0]));
		return $.cookie.apply(null, [cookie].concat($.makeArray(arguments)));
	},

	_ui: function(tab, panel) {
		return {
			tab: tab,
			panel: panel,
			index: this.anchors.index(tab)
		};
	},

	_cleanup: function() {
		this.lis.filter('.ui-state-processing').removeClass('ui-state-processing')
				.find('span:data(label.tabs)')
				.each(function() {
					var el = $(this);
					el.html(el.data('label.tabs')).removeData('label.tabs');
				});
	},

	_tabify: function(init) {

		this.list = this.element.children('ul:first');
		this.lis = $('li:has(a[href])', this.list);
		this.anchors = this.lis.map(function() { return $('a', this)[0]; });
		this.panels = $([]);

		var self = this, o = this.options;

		var fragmentId = /^#.+/; // Safari 2 reports '#' for an empty hash
		this.anchors.each(function(i, a) {
			var href = $(a).attr('href');

			var hrefBase = href.split('#')[0], baseEl;
			if (hrefBase && (hrefBase === location.toString().split('#')[0] ||
					(baseEl = $('base')[0]) && hrefBase === baseEl.href)) {
				href = a.hash;
				a.href = href;
			}

			if (fragmentId.test(href)) {
				self.panels = self.panels.add(self._sanitizeSelector(href));
			}

			else if (href != '#') { // prevent loading the page itself if href is just "#"
				$.data(a, 'href.tabs', href); // required for restore on destroy

				$.data(a, 'load.tabs', href.replace(/#.*$/, '')); // mutable data

				var id = self._tabId(a);
				a.href = '#' + id;
				var $panel = $('#' + id);
				if (!$panel.length) {
					$panel = $(o.panelTemplate).attr('id', id).addClass('ui-tabs-panel ui-widget-content ui-corner-bottom')
						.insertAfter(self.panels[i - 1] || self.list);
					$panel.data('destroy.tabs', true);
				}
				self.panels = self.panels.add($panel);
			}

			else {
				o.disabled.push(i);
			}
		});

		if (init) {

			this.element.addClass('ui-tabs ui-widget ui-widget-content ui-corner-all');
			this.list.addClass('ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all');
			this.lis.addClass('ui-state-default ui-corner-top');
			this.panels.addClass('ui-tabs-panel ui-widget-content ui-corner-bottom');

			if (o.selected === undefined) {
				if (location.hash) {
					this.anchors.each(function(i, a) {
						if (a.hash == location.hash) {
							o.selected = i;
							return false; // break
						}
					});
				}
				if (typeof o.selected != 'number' && o.cookie) {
					o.selected = parseInt(self._cookie(), 10);
				}
				if (typeof o.selected != 'number' && this.lis.filter('.ui-tabs-selected').length) {
					o.selected = this.lis.index(this.lis.filter('.ui-tabs-selected'));
				}
				o.selected = o.selected || 0;
			}
			else if (o.selected === null) { // usage of null is deprecated, TODO remove in next release
				o.selected = -1;
			}

			o.selected = ((o.selected >= 0 && this.anchors[o.selected]) || o.selected < 0) ? o.selected : 0;

			o.disabled = $.unique(o.disabled.concat(
				$.map(this.lis.filter('.ui-state-disabled'),
					function(n, i) { return self.lis.index(n); } )
			)).sort();

			if ($.inArray(o.selected, o.disabled) != -1) {
				o.disabled.splice($.inArray(o.selected, o.disabled), 1);
			}

			this.panels.addClass('ui-tabs-hide');
			this.lis.removeClass('ui-tabs-selected ui-state-active');
			if (o.selected >= 0 && this.anchors.length) { // check for length avoids error when initializing empty list
				this.panels.eq(o.selected).removeClass('ui-tabs-hide');
				this.lis.eq(o.selected).addClass('ui-tabs-selected ui-state-active');

				self.element.queue("tabs", function() {
					self._trigger('show', null, self._ui(self.anchors[o.selected], self.panels[o.selected]));
				});

				this.load(o.selected);
			}

			$(window).bind('unload', function() {
				self.lis.add(self.anchors).unbind('.tabs');
				self.lis = self.anchors = self.panels = null;
			});

		}
		else {
			o.selected = this.lis.index(this.lis.filter('.ui-tabs-selected'));
		}

		this.element[o.collapsible ? 'addClass' : 'removeClass']('ui-tabs-collapsible');

		if (o.cookie) {
			this._cookie(o.selected, o.cookie);
		}

		for (var i = 0, li; (li = this.lis[i]); i++) {
			$(li)[$.inArray(i, o.disabled) != -1 &&
				!$(li).hasClass('ui-tabs-selected') ? 'addClass' : 'removeClass']('ui-state-disabled');
		}

		if (o.cache === false) {
			this.anchors.removeData('cache.tabs');
		}

		this.lis.add(this.anchors).unbind('.tabs');

		if (o.event != 'mouseover') {
			var addState = function(state, el) {
				if (el.is(':not(.ui-state-disabled)')) {
					el.addClass('ui-state-' + state);
				}
			};
			var removeState = function(state, el) {
				el.removeClass('ui-state-' + state);
			};
			this.lis.bind('mouseover.tabs', function() {
				addState('hover', $(this));
			});
			this.lis.bind('mouseout.tabs', function() {
				removeState('hover', $(this));
			});
			this.anchors.bind('focus.tabs', function() {
				addState('focus', $(this).closest('li'));
			});
			this.anchors.bind('blur.tabs', function() {
				removeState('focus', $(this).closest('li'));
			});
		}

		var hideFx, showFx;
		if (o.fx) {
			if ($.isArray(o.fx)) {
				hideFx = o.fx[0];
				showFx = o.fx[1];
			}
			else {
				hideFx = showFx = o.fx;
			}
		}

		function resetStyle($el, fx) {
			$el.css({ display: '' });
			if ($.browser.msie && fx.opacity) {
				$el[0].style.removeAttribute('filter');
			}
		}

		var showTab = showFx ?
			function(clicked, $show) {
				$(clicked).closest('li').removeClass('ui-state-default').addClass('ui-tabs-selected ui-state-active');
				$show.hide().removeClass('ui-tabs-hide') // avoid flicker that way
					.animate(showFx, showFx.duration || 'normal', function() {
						resetStyle($show, showFx);
						self._trigger('show', null, self._ui(clicked, $show[0]));
					});
			} :
			function(clicked, $show) {
				$(clicked).closest('li').removeClass('ui-state-default').addClass('ui-tabs-selected ui-state-active');
				$show.removeClass('ui-tabs-hide');
				self._trigger('show', null, self._ui(clicked, $show[0]));
			};

		var hideTab = hideFx ?
			function(clicked, $hide) {
				$hide.animate(hideFx, hideFx.duration || 'normal', function() {
					self.lis.removeClass('ui-tabs-selected ui-state-active').addClass('ui-state-default');
					$hide.addClass('ui-tabs-hide');
					resetStyle($hide, hideFx);
					self.element.dequeue("tabs");
				});
			} :
			function(clicked, $hide, $show) {
				self.lis.removeClass('ui-tabs-selected ui-state-active').addClass('ui-state-default');
				$hide.addClass('ui-tabs-hide');
				self.element.dequeue("tabs");
			};

		this.anchors.bind(o.event + '.tabs', function() {
			var el = this, $li = $(this).closest('li'), $hide = self.panels.filter(':not(.ui-tabs-hide)'),
					$show = $(self._sanitizeSelector(this.hash));

			if (($li.hasClass('ui-tabs-selected') && !o.collapsible) ||
				$li.hasClass('ui-state-disabled') ||
				$li.hasClass('ui-state-processing') ||
				self._trigger('select', null, self._ui(this, $show[0])) === false) {
				this.blur();
				return false;
			}

			o.selected = self.anchors.index(this);

			self.abort();

			if (o.collapsible) {
				if ($li.hasClass('ui-tabs-selected')) {
					o.selected = -1;

					if (o.cookie) {
						self._cookie(o.selected, o.cookie);
					}

					self.element.queue("tabs", function() {
						hideTab(el, $hide);
					}).dequeue("tabs");

					this.blur();
					return false;
				}
				else if (!$hide.length) {
					if (o.cookie) {
						self._cookie(o.selected, o.cookie);
					}

					self.element.queue("tabs", function() {
						showTab(el, $show);
					});

					self.load(self.anchors.index(this)); // TODO make passing in node possible, see also http://dev.jqueryui.com/ticket/3171

					this.blur();
					return false;
				}
			}

			if (o.cookie) {
				self._cookie(o.selected, o.cookie);
			}

			if ($show.length) {
				if ($hide.length) {
					self.element.queue("tabs", function() {
						hideTab(el, $hide);
					});
				}
				self.element.queue("tabs", function() {
					showTab(el, $show);
				});

				self.load(self.anchors.index(this));
			}
			else {
				throw 'jQuery UI Tabs: Mismatching fragment identifier.';
			}

			if ($.browser.msie) {
				this.blur();
			}

		});

		this.anchors.bind('click.tabs', function(){return false;});

	},

	destroy: function() {
		var o = this.options;

		this.abort();

		this.element.unbind('.tabs')
			.removeClass('ui-tabs ui-widget ui-widget-content ui-corner-all ui-tabs-collapsible')
			.removeData('tabs');

		this.list.removeClass('ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all');

		this.anchors.each(function() {
			var href = $.data(this, 'href.tabs');
			if (href) {
				this.href = href;
			}
			var $this = $(this).unbind('.tabs');
			$.each(['href', 'load', 'cache'], function(i, prefix) {
				$this.removeData(prefix + '.tabs');
			});
		});

		this.lis.unbind('.tabs').add(this.panels).each(function() {
			if ($.data(this, 'destroy.tabs')) {
				$(this).remove();
			}
			else {
				$(this).removeClass([
					'ui-state-default',
					'ui-corner-top',
					'ui-tabs-selected',
					'ui-state-active',
					'ui-state-hover',
					'ui-state-focus',
					'ui-state-disabled',
					'ui-tabs-panel',
					'ui-widget-content',
					'ui-corner-bottom',
					'ui-tabs-hide'
				].join(' '));
			}
		});

		if (o.cookie) {
			this._cookie(null, o.cookie);
		}
	},

	add: function(url, label, index) {
		if (index === undefined) {
			index = this.anchors.length; // append by default
		}

		var self = this, o = this.options,
			$li = $(o.tabTemplate.replace(/#\{href\}/g, url).replace(/#\{label\}/g, label)),
			id = !url.indexOf('#') ? url.replace('#', '') : this._tabId($('a', $li)[0]);

		$li.addClass('ui-state-default ui-corner-top').data('destroy.tabs', true);

		var $panel = $('#' + id);
		if (!$panel.length) {
			$panel = $(o.panelTemplate).attr('id', id).data('destroy.tabs', true);
		}
		$panel.addClass('ui-tabs-panel ui-widget-content ui-corner-bottom ui-tabs-hide');

		if (index >= this.lis.length) {
			$li.appendTo(this.list);
			$panel.appendTo(this.list[0].parentNode);
		}
		else {
			$li.insertBefore(this.lis[index]);
			$panel.insertBefore(this.panels[index]);
		}

		o.disabled = $.map(o.disabled,
			function(n, i) { return n >= index ? ++n : n; });

		this._tabify();

		if (this.anchors.length == 1) { // after tabify
			$li.addClass('ui-tabs-selected ui-state-active');
			$panel.removeClass('ui-tabs-hide');
			this.element.queue("tabs", function() {
				self._trigger('show', null, self._ui(self.anchors[0], self.panels[0]));
			});

			this.load(0);
		}

		this._trigger('add', null, this._ui(this.anchors[index], this.panels[index]));
	},

	remove: function(index) {
		var o = this.options, $li = this.lis.eq(index).remove(),
			$panel = this.panels.eq(index).remove();

		if ($li.hasClass('ui-tabs-selected') && this.anchors.length > 1) {
			this.select(index + (index + 1 < this.anchors.length ? 1 : -1));
		}

		o.disabled = $.map($.grep(o.disabled, function(n, i) { return n != index; }),
			function(n, i) { return n >= index ? --n : n; });

		this._tabify();

		this._trigger('remove', null, this._ui($li.find('a')[0], $panel[0]));
	},

	enable: function(index) {
		var o = this.options;
		if ($.inArray(index, o.disabled) == -1) {
			return;
		}

		this.lis.eq(index).removeClass('ui-state-disabled');
		o.disabled = $.grep(o.disabled, function(n, i) { return n != index; });

		this._trigger('enable', null, this._ui(this.anchors[index], this.panels[index]));
	},

	disable: function(index) {
		var self = this, o = this.options;
		if (index != o.selected) { // cannot disable already selected tab
			this.lis.eq(index).addClass('ui-state-disabled');

			o.disabled.push(index);
			o.disabled.sort();

			this._trigger('disable', null, this._ui(this.anchors[index], this.panels[index]));
		}
	},

	select: function(index) {
		if (typeof index == 'string') {
			index = this.anchors.index(this.anchors.filter('[href$=' + index + ']'));
		}
		else if (index === null) { // usage of null is deprecated, TODO remove in next release
			index = -1;
		}
		if (index == -1 && this.options.collapsible) {
			index = this.options.selected;
		}

		this.anchors.eq(index).trigger(this.options.event + '.tabs');
	},

	load: function(index) {
		var self = this, o = this.options, a = this.anchors.eq(index)[0], url = $.data(a, 'load.tabs');

		this.abort();

		if (!url || this.element.queue("tabs").length !== 0 && $.data(a, 'cache.tabs')) {
			this.element.dequeue("tabs");
			return;
		}

		this.lis.eq(index).addClass('ui-state-processing');

		if (o.spinner) {
			var span = $('span', a);
			span.data('label.tabs', span.html()).html(o.spinner);
		}

		this.xhr = $.ajax($.extend({}, o.ajaxOptions, {
			url: url,
			success: function(r, s) {
				$(self._sanitizeSelector(a.hash)).html(r);

				self._cleanup();

				if (o.cache) {
					$.data(a, 'cache.tabs', true); // if loaded once do not load them again
				}

				self._trigger('load', null, self._ui(self.anchors[index], self.panels[index]));
				try {
					o.ajaxOptions.success(r, s);
				}
				catch (e) {}

				self.element.dequeue("tabs");
			}
		}));
	},

	abort: function() {
		this.element.queue([]);
		this.panels.stop(false, true);

		if (this.xhr) {
			this.xhr.abort();
			delete this.xhr;
		}

		this._cleanup();

	},

	url: function(index, url) {
		this.anchors.eq(index).removeData('cache.tabs').data('load.tabs', url);
	},

	length: function() {
		return this.anchors.length;
	}

});

$.extend($.ui.tabs, {
	version: '1.7.2',
	getter: 'length',
	defaults: {
		ajaxOptions: null,
		cache: false,
		cookie: null, // e.g. { expires: 7, path: '/', domain: 'jquery.com', secure: true }
		collapsible: false,
		disabled: [],
		event: 'click',
		fx: null, // e.g. { height: 'toggle', opacity: 'toggle', duration: 200 }
		idPrefix: 'ui-tabs-',
		panelTemplate: '<div></div>',
		spinner: '<em>Loading&#8230;</em>',
		tabTemplate: '<li><a href="#{href}"><span>#{label}</span></a></li>'
	}
});

/*
 * Tabs Extensions
 */

/*
 * Rotate
 */
$.extend($.ui.tabs.prototype, {
	rotation: null,
	rotate: function(ms, continuing) {

		var self = this, o = this.options;

		var rotate = self._rotate || (self._rotate = function(e) {
			clearTimeout(self.rotation);
			self.rotation = setTimeout(function() {
				var t = o.selected;
				self.select( ++t < self.anchors.length ? t : 0 );
			}, ms);

			if (e) {
				e.stopPropagation();
			}
		});

		var stop = self._unrotate || (self._unrotate = !continuing ?
			function(e) {
				if (e.clientX) { // in case of a true click
					self.rotate(null);
				}
			} :
			function(e) {
				t = o.selected;
				rotate();
			});

		if (ms) {
			this.element.bind('tabsshow', rotate);
			this.anchors.bind(o.event + '.tabs', stop);
			rotate();
		}
		else {
			clearTimeout(self.rotation);
			this.element.unbind('tabsshow', rotate);
			this.anchors.unbind(o.event + '.tabs', stop);
			delete this._rotate;
			delete this._unrotate;
		}
	}
});

})(jQuery);
/*
 * jQuery UI Datepicker 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Datepicker
 *
 * Depends:
 *	ui.core.js
 */

(function($) { // hide the namespace

$.extend($.ui, { datepicker: { version: "1.7.2" } });

var PROP_NAME = 'datepicker';

/* Date picker manager.
   Use the singleton instance of this class, $.datepicker, to interact with the date picker.
   Settings for (groups of) date pickers are maintained in an instance object,
   allowing multiple different settings on the same page. */

function Datepicker() {
	this.debug = false; // Change this to true to start debugging
	this._curInst = null; // The current instance in use
	this._keyEvent = false; // If the last event was a key event
	this._disabledInputs = []; // List of date picker inputs that have been disabled
	this._datepickerShowing = false; // True if the popup picker is showing , false if not
	this._inDialog = false; // True if showing within a "dialog", false if not
	this._mainDivId = 'ui-datepicker-div'; // The ID of the main datepicker division
	this._inlineClass = 'ui-datepicker-inline'; // The name of the inline marker class
	this._appendClass = 'ui-datepicker-append'; // The name of the append marker class
	this._triggerClass = 'ui-datepicker-trigger'; // The name of the trigger marker class
	this._dialogClass = 'ui-datepicker-dialog'; // The name of the dialog marker class
	this._disableClass = 'ui-datepicker-disabled'; // The name of the disabled covering marker class
	this._unselectableClass = 'ui-datepicker-unselectable'; // The name of the unselectable cell marker class
	this._currentClass = 'ui-datepicker-current-day'; // The name of the current day marker class
	this._dayOverClass = 'ui-datepicker-days-cell-over'; // The name of the day hover marker class
	this.regional = []; // Available regional settings, indexed by language code
	this.regional[''] = { // Default regional settings
		closeText: 'Done', // Display text for close link
		prevText: 'Prev', // Display text for previous month link
		nextText: 'Next', // Display text for next month link
		currentText: 'Today', // Display text for current month link
		monthNames: ['January','February','March','April','May','June',
			'July','August','September','October','November','December'], // Names of months for drop-down and formatting
		monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'], // For formatting
		dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'], // For formatting
		dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'], // For formatting
		dayNamesMin: ['Su','Mo','Tu','We','Th','Fr','Sa'], // Column headings for days starting at Sunday
		dateFormat: 'mm/dd/yy', // See format options on parseDate
		firstDay: 0, // The first day of the week, Sun = 0, Mon = 1, ...
		isRTL: false // True if right-to-left language, false if left-to-right
	};
	this._defaults = { // Global defaults for all the date picker instances
		showOn: 'focus', // 'focus' for popup on focus,
		showAnim: 'show', // Name of jQuery animation for popup
		showOptions: {}, // Options for enhanced animations
		defaultDate: null, // Used when field is blank: actual date,
		appendText: '', // Display text following the input box, e.g. showing the format
		buttonText: '...', // Text for trigger button
		buttonImage: '', // URL for trigger button image
		buttonImageOnly: false, // True if the image appears alone, false if it appears on a button
		hideIfNoPrevNext: false, // True to hide next/previous month links
		navigationAsDateFormat: false, // True if date formatting applied to prev/today/next links
		gotoCurrent: false, // True if today link goes back to current selection instead
		changeMonth: false, // True if month can be selected directly, false if only prev/next
		changeYear: false, // True if year can be selected directly, false if only prev/next
		showMonthAfterYear: false, // True if the year select precedes month, false for month then year
		yearRange: '-10:+10', // Range of years to display in drop-down,
		showOtherMonths: false, // True to show dates in other months, false to leave blank
		calculateWeek: this.iso8601Week, // How to calculate the week of the year,
		shortYearCutoff: '+10', // Short year values < this are in the current century,
		minDate: null, // The earliest selectable date, or null for no limit
		maxDate: null, // The latest selectable date, or null for no limit
		duration: 'normal', // Duration of display/closure
		beforeShowDay: null, // Function that takes a date and returns an array with
		beforeShow: null, // Function that takes an input field and
		onSelect: null, // Define a callback function when a date is selected
		onChangeMonthYear: null, // Define a callback function when the month or year is changed
		onClose: null, // Define a callback function when the datepicker is closed
		numberOfMonths: 1, // Number of months to show at a time
		showCurrentAtPos: 0, // The position in multipe months at which to show the current month (starting at 0)
		stepMonths: 1, // Number of months to step back/forward
		stepBigMonths: 12, // Number of months to step back/forward for the big links
		altField: '', // Selector for an alternate field to store selected dates into
		altFormat: '', // The date format to use for the alternate field
		constrainInput: true, // The input is constrained by the current date format
		showButtonPanel: false // True to show button panel, false to not show it
	};
	$.extend(this._defaults, this.regional['']);
	this.dpDiv = $('<div id="' + this._mainDivId + '" class="ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all ui-helper-hidden-accessible"></div>');
}

$.extend(Datepicker.prototype, {
	/* Class name added to elements to indicate already configured with a date picker. */
	markerClassName: 'hasDatepicker',

	/* Debug logging (if enabled). */
	log: function () {
		if (this.debug)
			console.log.apply('', arguments);
	},

	/* Override the default settings for all instances of the date picker.
	   @param  settings  object - the new settings to use as defaults (anonymous object)
	   @return the manager object */
	setDefaults: function(settings) {
		extendRemove(this._defaults, settings || {});
		return this;
	},

	/* Attach the date picker to a jQuery selection.
	   @param  target    element - the target input field or division or span
	   @param  settings  object - the new settings to use for this date picker instance (anonymous) */
	_attachDatepicker: function(target, settings) {
		var inlineSettings = null;
		for (var attrName in this._defaults) {
			var attrValue = target.getAttribute('date:' + attrName);
			if (attrValue) {
				inlineSettings = inlineSettings || {};
				try {
					inlineSettings[attrName] = eval(attrValue);
				} catch (err) {
					inlineSettings[attrName] = attrValue;
				}
			}
		}
		var nodeName = target.nodeName.toLowerCase();
		var inline = (nodeName == 'div' || nodeName == 'span');
		if (!target.id)
			target.id = 'dp' + (++this.uuid);
		var inst = this._newInst($(target), inline);
		inst.settings = $.extend({}, settings || {}, inlineSettings || {});
		if (nodeName == 'input') {
			this._connectDatepicker(target, inst);
		} else if (inline) {
			this._inlineDatepicker(target, inst);
		}
	},

	/* Create a new instance object. */
	_newInst: function(target, inline) {
		var id = target[0].id.replace(/([:\[\]\.])/g, '\\\\$1'); // escape jQuery meta chars
		return {id: id, input: target, // associated target
			selectedDay: 0, selectedMonth: 0, selectedYear: 0, // current selection
			drawMonth: 0, drawYear: 0, // month being drawn
			inline: inline, // is datepicker inline or not
			dpDiv: (!inline ? this.dpDiv : // presentation div
			$('<div class="' + this._inlineClass + ' ui-datepicker ui-widget ui-widget-content ui-helper-clearfix ui-corner-all"></div>'))};
	},

	/* Attach the date picker to an input field. */
	_connectDatepicker: function(target, inst) {
		var input = $(target);
		inst.append = $([]);
		inst.trigger = $([]);
		if (input.hasClass(this.markerClassName))
			return;
		var appendText = this._get(inst, 'appendText');
		var isRTL = this._get(inst, 'isRTL');
		if (appendText) {
			inst.append = $('<span class="' + this._appendClass + '">' + appendText + '</span>');
			input[isRTL ? 'before' : 'after'](inst.append);
		}
		var showOn = this._get(inst, 'showOn');
		if (showOn == 'focus' || showOn == 'both') // pop-up date picker when in the marked field
			input.focus(this._showDatepicker);
		if (showOn == 'button' || showOn == 'both') { // pop-up date picker when button clicked
			var buttonText = this._get(inst, 'buttonText');
			var buttonImage = this._get(inst, 'buttonImage');
			inst.trigger = $(this._get(inst, 'buttonImageOnly') ?
				$('<img/>').addClass(this._triggerClass).
					attr({ src: buttonImage, alt: buttonText, title: buttonText }) :
				$('<button type="button"></button>').addClass(this._triggerClass).
					html(buttonImage == '' ? buttonText : $('<img/>').attr(
					{ src:buttonImage, alt:buttonText, title:buttonText })));
			input[isRTL ? 'before' : 'after'](inst.trigger);
			inst.trigger.click(function() {
				if ($.datepicker._datepickerShowing && $.datepicker._lastInput == target)
					$.datepicker._hideDatepicker();
				else
					$.datepicker._showDatepicker(target);
				return false;
			});
		}
		input.addClass(this.markerClassName).keydown(this._doKeyDown).keypress(this._doKeyPress).
			bind("setData.datepicker", function(event, key, value) {
				inst.settings[key] = value;
			}).bind("getData.datepicker", function(event, key) {
				return this._get(inst, key);
			});
		$.data(target, PROP_NAME, inst);
	},

	/* Attach an inline date picker to a div. */
	_inlineDatepicker: function(target, inst) {
		var divSpan = $(target);
		if (divSpan.hasClass(this.markerClassName))
			return;
		divSpan.addClass(this.markerClassName).append(inst.dpDiv).
			bind("setData.datepicker", function(event, key, value){
				inst.settings[key] = value;
			}).bind("getData.datepicker", function(event, key){
				return this._get(inst, key);
			});
		$.data(target, PROP_NAME, inst);
		this._setDate(inst, this._getDefaultDate(inst));
		this._updateDatepicker(inst);
		this._updateAlternate(inst);
	},

	/* Pop-up the date picker in a "dialog" box.
	   @param  input     element - ignored
	   @param  dateText  string - the initial date to display (in the current format)
	   @param  onSelect  function - the function(dateText) to call when a date is selected
	   @param  settings  object - update the dialog date picker instance's settings (anonymous object)
	   @param  pos       int[2] - coordinates for the dialog's position within the screen or
	                     event - with x/y coordinates or
	                     leave empty for default (screen centre)
	   @return the manager object */
	_dialogDatepicker: function(input, dateText, onSelect, settings, pos) {
		var inst = this._dialogInst; // internal instance
		if (!inst) {
			var id = 'dp' + (++this.uuid);
			this._dialogInput = $('<input type="text" id="' + id +
				'" size="1" style="position: absolute; top: -100px;"/>');
			this._dialogInput.keydown(this._doKeyDown);
			$('body').append(this._dialogInput);
			inst = this._dialogInst = this._newInst(this._dialogInput, false);
			inst.settings = {};
			$.data(this._dialogInput[0], PROP_NAME, inst);
		}
		extendRemove(inst.settings, settings || {});
		this._dialogInput.val(dateText);

		this._pos = (pos ? (pos.length ? pos : [pos.pageX, pos.pageY]) : null);
		if (!this._pos) {
			var browserWidth = window.innerWidth || document.documentElement.clientWidth ||	document.body.clientWidth;
			var browserHeight = window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight;
			var scrollX = document.documentElement.scrollLeft || document.body.scrollLeft;
			var scrollY = document.documentElement.scrollTop || document.body.scrollTop;
			this._pos = // should use actual width/height below
				[(browserWidth / 2) - 100 + scrollX, (browserHeight / 2) - 150 + scrollY];
		}

		this._dialogInput.css('left', this._pos[0] + 'px').css('top', this._pos[1] + 'px');
		inst.settings.onSelect = onSelect;
		this._inDialog = true;
		this.dpDiv.addClass(this._dialogClass);
		this._showDatepicker(this._dialogInput[0]);
		if ($.blockUI)
			$.blockUI(this.dpDiv);
		$.data(this._dialogInput[0], PROP_NAME, inst);
		return this;
	},

	/* Detach a datepicker from its control.
	   @param  target    element - the target input field or division or span */
	_destroyDatepicker: function(target) {
		var $target = $(target);
		var inst = $.data(target, PROP_NAME);
		if (!$target.hasClass(this.markerClassName)) {
			return;
		}
		var nodeName = target.nodeName.toLowerCase();
		$.removeData(target, PROP_NAME);
		if (nodeName == 'input') {
			inst.append.remove();
			inst.trigger.remove();
			$target.removeClass(this.markerClassName).
				unbind('focus', this._showDatepicker).
				unbind('keydown', this._doKeyDown).
				unbind('keypress', this._doKeyPress);
		} else if (nodeName == 'div' || nodeName == 'span')
			$target.removeClass(this.markerClassName).empty();
	},

	/* Enable the date picker to a jQuery selection.
	   @param  target    element - the target input field or division or span */
	_enableDatepicker: function(target) {
		var $target = $(target);
		var inst = $.data(target, PROP_NAME);
		if (!$target.hasClass(this.markerClassName)) {
			return;
		}
		var nodeName = target.nodeName.toLowerCase();
		if (nodeName == 'input') {
			target.disabled = false;
			inst.trigger.filter('button').
				each(function() { this.disabled = false; }).end().
				filter('img').css({opacity: '1.0', cursor: ''});
		}
		else if (nodeName == 'div' || nodeName == 'span') {
			var inline = $target.children('.' + this._inlineClass);
			inline.children().removeClass('ui-state-disabled');
		}
		this._disabledInputs = $.map(this._disabledInputs,
			function(value) { return (value == target ? null : value); }); // delete entry
	},

	/* Disable the date picker to a jQuery selection.
	   @param  target    element - the target input field or division or span */
	_disableDatepicker: function(target) {
		var $target = $(target);
		var inst = $.data(target, PROP_NAME);
		if (!$target.hasClass(this.markerClassName)) {
			return;
		}
		var nodeName = target.nodeName.toLowerCase();
		if (nodeName == 'input') {
			target.disabled = true;
			inst.trigger.filter('button').
				each(function() { this.disabled = true; }).end().
				filter('img').css({opacity: '0.5', cursor: 'default'});
		}
		else if (nodeName == 'div' || nodeName == 'span') {
			var inline = $target.children('.' + this._inlineClass);
			inline.children().addClass('ui-state-disabled');
		}
		this._disabledInputs = $.map(this._disabledInputs,
			function(value) { return (value == target ? null : value); }); // delete entry
		this._disabledInputs[this._disabledInputs.length] = target;
	},

	/* Is the first field in a jQuery collection disabled as a datepicker?
	   @param  target    element - the target input field or division or span
	   @return boolean - true if disabled, false if enabled */
	_isDisabledDatepicker: function(target) {
		if (!target) {
			return false;
		}
		for (var i = 0; i < this._disabledInputs.length; i++) {
			if (this._disabledInputs[i] == target)
				return true;
		}
		return false;
	},

	/* Retrieve the instance data for the target control.
	   @param  target  element - the target input field or division or span
	   @return  object - the associated instance data
	   @throws  error if a jQuery problem getting data */
	_getInst: function(target) {
		try {
			return $.data(target, PROP_NAME);
		}
		catch (err) {
			throw 'Missing instance data for this datepicker';
		}
	},

	/* Update or retrieve the settings for a date picker attached to an input field or division.
	   @param  target  element - the target input field or division or span
	   @param  name    object - the new settings to update or
	                   string - the name of the setting to change or retrieve,
	                   when retrieving also 'all' for all instance settings or
	                   'defaults' for all global defaults
	   @param  value   any - the new value for the setting
	                   (omit if above is an object or to retrieve a value) */
	_optionDatepicker: function(target, name, value) {
		var inst = this._getInst(target);
		if (arguments.length == 2 && typeof name == 'string') {
			return (name == 'defaults' ? $.extend({}, $.datepicker._defaults) :
				(inst ? (name == 'all' ? $.extend({}, inst.settings) :
				this._get(inst, name)) : null));
		}
		var settings = name || {};
		if (typeof name == 'string') {
			settings = {};
			settings[name] = value;
		}
		if (inst) {
			if (this._curInst == inst) {
				this._hideDatepicker(null);
			}
			var date = this._getDateDatepicker(target);
			extendRemove(inst.settings, settings);
			this._setDateDatepicker(target, date);
			this._updateDatepicker(inst);
		}
	},

	_changeDatepicker: function(target, name, value) {
		this._optionDatepicker(target, name, value);
	},

	/* Redraw the date picker attached to an input field or division.
	   @param  target  element - the target input field or division or span */
	_refreshDatepicker: function(target) {
		var inst = this._getInst(target);
		if (inst) {
			this._updateDatepicker(inst);
		}
	},

	/* Set the dates for a jQuery selection.
	   @param  target   element - the target input field or division or span
	   @param  date     Date - the new date
	   @param  endDate  Date - the new end date for a range (optional) */
	_setDateDatepicker: function(target, date, endDate) {
		var inst = this._getInst(target);
		if (inst) {
			this._setDate(inst, date, endDate);
			this._updateDatepicker(inst);
			this._updateAlternate(inst);
		}
	},

	/* Get the date(s) for the first entry in a jQuery selection.
	   @param  target  element - the target input field or division or span
	   @return Date - the current date or
	           Date[2] - the current dates for a range */
	_getDateDatepicker: function(target) {
		var inst = this._getInst(target);
		if (inst && !inst.inline)
			this._setDateFromField(inst);
		return (inst ? this._getDate(inst) : null);
	},

	/* Handle keystrokes. */
	_doKeyDown: function(event) {
		var inst = $.datepicker._getInst(event.target);
		var handled = true;
		var isRTL = inst.dpDiv.is('.ui-datepicker-rtl');
		inst._keyEvent = true;
		if ($.datepicker._datepickerShowing)
			switch (event.keyCode) {
				case 9:  $.datepicker._hideDatepicker(null, '');
						break; // hide on tab out
				case 13: var sel = $('td.' + $.datepicker._dayOverClass +
							', td.' + $.datepicker._currentClass, inst.dpDiv);
						if (sel[0])
							$.datepicker._selectDay(event.target, inst.selectedMonth, inst.selectedYear, sel[0]);
						else
							$.datepicker._hideDatepicker(null, $.datepicker._get(inst, 'duration'));
						return false; // don't submit the form
						break; // select the value on enter
				case 27: $.datepicker._hideDatepicker(null, $.datepicker._get(inst, 'duration'));
						break; // hide on escape
				case 33: $.datepicker._adjustDate(event.target, (event.ctrlKey ?
							-$.datepicker._get(inst, 'stepBigMonths') :
							-$.datepicker._get(inst, 'stepMonths')), 'M');
						break; // previous month/year on page up/+ ctrl
				case 34: $.datepicker._adjustDate(event.target, (event.ctrlKey ?
							+$.datepicker._get(inst, 'stepBigMonths') :
							+$.datepicker._get(inst, 'stepMonths')), 'M');
						break; // next month/year on page down/+ ctrl
				case 35: if (event.ctrlKey || event.metaKey) $.datepicker._clearDate(event.target);
						handled = event.ctrlKey || event.metaKey;
						break; // clear on ctrl or command +end
				case 36: if (event.ctrlKey || event.metaKey) $.datepicker._gotoToday(event.target);
						handled = event.ctrlKey || event.metaKey;
						break; // current on ctrl or command +home
				case 37: if (event.ctrlKey || event.metaKey) $.datepicker._adjustDate(event.target, (isRTL ? +1 : -1), 'D');
						handled = event.ctrlKey || event.metaKey;
						if (event.originalEvent.altKey) $.datepicker._adjustDate(event.target, (event.ctrlKey ?
									-$.datepicker._get(inst, 'stepBigMonths') :
									-$.datepicker._get(inst, 'stepMonths')), 'M');
						break;
				case 38: if (event.ctrlKey || event.metaKey) $.datepicker._adjustDate(event.target, -7, 'D');
						handled = event.ctrlKey || event.metaKey;
						break; // -1 week on ctrl or command +up
				case 39: if (event.ctrlKey || event.metaKey) $.datepicker._adjustDate(event.target, (isRTL ? -1 : +1), 'D');
						handled = event.ctrlKey || event.metaKey;
						if (event.originalEvent.altKey) $.datepicker._adjustDate(event.target, (event.ctrlKey ?
									+$.datepicker._get(inst, 'stepBigMonths') :
									+$.datepicker._get(inst, 'stepMonths')), 'M');
						break;
				case 40: if (event.ctrlKey || event.metaKey) $.datepicker._adjustDate(event.target, +7, 'D');
						handled = event.ctrlKey || event.metaKey;
						break; // +1 week on ctrl or command +down
				default: handled = false;
			}
		else if (event.keyCode == 36 && event.ctrlKey) // display the date picker on ctrl+home
			$.datepicker._showDatepicker(this);
		else {
			handled = false;
		}
		if (handled) {
			event.preventDefault();
			event.stopPropagation();
		}
	},

	/* Filter entered characters - based on date format. */
	_doKeyPress: function(event) {
		var inst = $.datepicker._getInst(event.target);
		if ($.datepicker._get(inst, 'constrainInput')) {
			var chars = $.datepicker._possibleChars($.datepicker._get(inst, 'dateFormat'));
			var chr = String.fromCharCode(event.charCode == undefined ? event.keyCode : event.charCode);
			return event.ctrlKey || (chr < ' ' || !chars || chars.indexOf(chr) > -1);
		}
	},

	/* Pop-up the date picker for a given input field.
	   @param  input  element - the input field attached to the date picker or
	                  event - if triggered by focus */
	_showDatepicker: function(input) {
		input = input.target || input;
		if (input.nodeName.toLowerCase() != 'input') // find from button/image trigger
			input = $('input', input.parentNode)[0];
		if ($.datepicker._isDisabledDatepicker(input) || $.datepicker._lastInput == input) // already here
			return;
		var inst = $.datepicker._getInst(input);
		var beforeShow = $.datepicker._get(inst, 'beforeShow');
		extendRemove(inst.settings, (beforeShow ? beforeShow.apply(input, [input, inst]) : {}));
		$.datepicker._hideDatepicker(null, '');
		$.datepicker._lastInput = input;
		$.datepicker._setDateFromField(inst);
		if ($.datepicker._inDialog) // hide cursor
			input.value = '';
		if (!$.datepicker._pos) { // position below input
			$.datepicker._pos = $.datepicker._findPos(input);
			$.datepicker._pos[1] += input.offsetHeight; // add the height
		}
		var isFixed = false;
		$(input).parents().each(function() {
			isFixed |= $(this).css('position') == 'fixed';
			return !isFixed;
		});
		if (isFixed && $.browser.opera) { // correction for Opera when fixed and scrolled
			$.datepicker._pos[0] -= document.documentElement.scrollLeft;
			$.datepicker._pos[1] -= document.documentElement.scrollTop;
		}
		var offset = {left: $.datepicker._pos[0], top: $.datepicker._pos[1]};
		$.datepicker._pos = null;
		inst.rangeStart = null;
		inst.dpDiv.css({position: 'absolute', display: 'block', top: '-1000px'});
		$.datepicker._updateDatepicker(inst);
		offset = $.datepicker._checkOffset(inst, offset, isFixed);
		inst.dpDiv.css({position: ($.datepicker._inDialog && $.blockUI ?
			'static' : (isFixed ? 'fixed' : 'absolute')), display: 'none',
			left: offset.left + 'px', top: offset.top + 'px'});
		if (!inst.inline) {
			var showAnim = $.datepicker._get(inst, 'showAnim') || 'show';
			var duration = $.datepicker._get(inst, 'duration');
			var postProcess = function() {
				$.datepicker._datepickerShowing = true;
				if ($.browser.msie && parseInt($.browser.version,10) < 7) // fix IE < 7 select problems
					$('iframe.ui-datepicker-cover').css({width: inst.dpDiv.width() + 4,
						height: inst.dpDiv.height() + 4});
			};
			if ($.effects && $.effects[showAnim])
				inst.dpDiv.show(showAnim, $.datepicker._get(inst, 'showOptions'), duration, postProcess);
			else
				inst.dpDiv[showAnim](duration, postProcess);
			if (duration == '')
				postProcess();
			if (inst.input[0].type != 'hidden')
				inst.input[0].focus();
			$.datepicker._curInst = inst;
		}
	},

	/* Generate the date picker content. */
	_updateDatepicker: function(inst) {
		var dims = {width: inst.dpDiv.width() + 4,
			height: inst.dpDiv.height() + 4};
		var self = this;
		inst.dpDiv.empty().append(this._generateHTML(inst))
			.find('iframe.ui-datepicker-cover').
				css({width: dims.width, height: dims.height})
			.end()
			.find('button, .ui-datepicker-prev, .ui-datepicker-next, .ui-datepicker-calendar td a')
				.bind('mouseout', function(){
					$(this).removeClass('ui-state-hover');
					if(this.className.indexOf('ui-datepicker-prev') != -1) $(this).removeClass('ui-datepicker-prev-hover');
					if(this.className.indexOf('ui-datepicker-next') != -1) $(this).removeClass('ui-datepicker-next-hover');
				})
				.bind('mouseover', function(){
					if (!self._isDisabledDatepicker( inst.inline ? inst.dpDiv.parent()[0] : inst.input[0])) {
						$(this).parents('.ui-datepicker-calendar').find('a').removeClass('ui-state-hover');
						$(this).addClass('ui-state-hover');
						if(this.className.indexOf('ui-datepicker-prev') != -1) $(this).addClass('ui-datepicker-prev-hover');
						if(this.className.indexOf('ui-datepicker-next') != -1) $(this).addClass('ui-datepicker-next-hover');
					}
				})
			.end()
			.find('.' + this._dayOverClass + ' a')
				.trigger('mouseover')
			.end();
		var numMonths = this._getNumberOfMonths(inst);
		var cols = numMonths[1];
		var width = 17;
		if (cols > 1) {
			inst.dpDiv.addClass('ui-datepicker-multi-' + cols).css('width', (width * cols) + 'em');
		} else {
			inst.dpDiv.removeClass('ui-datepicker-multi-2 ui-datepicker-multi-3 ui-datepicker-multi-4').width('');
		}
		inst.dpDiv[(numMonths[0] != 1 || numMonths[1] != 1 ? 'add' : 'remove') +
			'Class']('ui-datepicker-multi');
		inst.dpDiv[(this._get(inst, 'isRTL') ? 'add' : 'remove') +
			'Class']('ui-datepicker-rtl');
		if (inst.input && inst.input[0].type != 'hidden' && inst == $.datepicker._curInst)
			$(inst.input[0]).focus();
	},

	/* Check positioning to remain on screen. */
	_checkOffset: function(inst, offset, isFixed) {
		var dpWidth = inst.dpDiv.outerWidth();
		var dpHeight = inst.dpDiv.outerHeight();
		var inputWidth = inst.input ? inst.input.outerWidth() : 0;
		var inputHeight = inst.input ? inst.input.outerHeight() : 0;
		var viewWidth = (window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth) + $(document).scrollLeft();
		var viewHeight = (window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight) + $(document).scrollTop();

		offset.left -= (this._get(inst, 'isRTL') ? (dpWidth - inputWidth) : 0);
		offset.left -= (isFixed && offset.left == inst.input.offset().left) ? $(document).scrollLeft() : 0;
		offset.top -= (isFixed && offset.top == (inst.input.offset().top + inputHeight)) ? $(document).scrollTop() : 0;

		offset.left -= (offset.left + dpWidth > viewWidth && viewWidth > dpWidth) ? Math.abs(offset.left + dpWidth - viewWidth) : 0;
		offset.top -= (offset.top + dpHeight > viewHeight && viewHeight > dpHeight) ? Math.abs(offset.top + dpHeight + inputHeight*2 - viewHeight) : 0;

		return offset;
	},

	/* Find an object's position on the screen. */
	_findPos: function(obj) {
        while (obj && (obj.type == 'hidden' || obj.nodeType != 1)) {
            obj = obj.nextSibling;
        }
        var position = $(obj).offset();
	    return [position.left, position.top];
	},

	/* Hide the date picker from view.
	   @param  input  element - the input field attached to the date picker
	   @param  duration  string - the duration over which to close the date picker */
	_hideDatepicker: function(input, duration) {
		var inst = this._curInst;
		if (!inst || (input && inst != $.data(input, PROP_NAME)))
			return;
		if (inst.stayOpen)
			this._selectDate('#' + inst.id, this._formatDate(inst,
				inst.currentDay, inst.currentMonth, inst.currentYear));
		inst.stayOpen = false;
		if (this._datepickerShowing) {
			duration = (duration != null ? duration : this._get(inst, 'duration'));
			var showAnim = this._get(inst, 'showAnim');
			var postProcess = function() {
				$.datepicker._tidyDialog(inst);
			};
			if (duration != '' && $.effects && $.effects[showAnim])
				inst.dpDiv.hide(showAnim, $.datepicker._get(inst, 'showOptions'),
					duration, postProcess);
			else
				inst.dpDiv[(duration == '' ? 'hide' : (showAnim == 'slideDown' ? 'slideUp' :
					(showAnim == 'fadeIn' ? 'fadeOut' : 'hide')))](duration, postProcess);
			if (duration == '')
				this._tidyDialog(inst);
			var onClose = this._get(inst, 'onClose');
			if (onClose)
				onClose.apply((inst.input ? inst.input[0] : null),
					[(inst.input ? inst.input.val() : ''), inst]);  // trigger custom callback
			this._datepickerShowing = false;
			this._lastInput = null;
			if (this._inDialog) {
				this._dialogInput.css({ position: 'absolute', left: '0', top: '-100px' });
				if ($.blockUI) {
					$.unblockUI();
					$('body').append(this.dpDiv);
				}
			}
			this._inDialog = false;
		}
		this._curInst = null;
	},

	/* Tidy up after a dialog display. */
	_tidyDialog: function(inst) {
		inst.dpDiv.removeClass(this._dialogClass).unbind('.ui-datepicker-calendar');
	},

	/* Close date picker if clicked elsewhere. */
	_checkExternalClick: function(event) {
		if (!$.datepicker._curInst)
			return;
		var $target = $(event.target);
		if (($target.parents('#' + $.datepicker._mainDivId).length == 0) &&
				!$target.hasClass($.datepicker.markerClassName) &&
				!$target.hasClass($.datepicker._triggerClass) &&
				$.datepicker._datepickerShowing && !($.datepicker._inDialog && $.blockUI))
			$.datepicker._hideDatepicker(null, '');
	},

	/* Adjust one of the date sub-fields. */
	_adjustDate: function(id, offset, period) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		if (this._isDisabledDatepicker(target[0])) {
			return;
		}
		this._adjustInstDate(inst, offset +
			(period == 'M' ? this._get(inst, 'showCurrentAtPos') : 0), // undo positioning
			period);
		this._updateDatepicker(inst);
	},

	/* Action for current link. */
	_gotoToday: function(id) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		if (this._get(inst, 'gotoCurrent') && inst.currentDay) {
			inst.selectedDay = inst.currentDay;
			inst.drawMonth = inst.selectedMonth = inst.currentMonth;
			inst.drawYear = inst.selectedYear = inst.currentYear;
		}
		else {
		var date = new Date();
		inst.selectedDay = date.getDate();
		inst.drawMonth = inst.selectedMonth = date.getMonth();
		inst.drawYear = inst.selectedYear = date.getFullYear();
		}
		this._notifyChange(inst);
		this._adjustDate(target);
	},

	/* Action for selecting a new month/year. */
	_selectMonthYear: function(id, select, period) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		inst._selectingMonthYear = false;
		inst['selected' + (period == 'M' ? 'Month' : 'Year')] =
		inst['draw' + (period == 'M' ? 'Month' : 'Year')] =
			parseInt(select.options[select.selectedIndex].value,10);
		this._notifyChange(inst);
		this._adjustDate(target);
	},

	/* Restore input focus after not changing month/year. */
	_clickMonthYear: function(id) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		if (inst.input && inst._selectingMonthYear && !$.browser.msie)
			inst.input[0].focus();
		inst._selectingMonthYear = !inst._selectingMonthYear;
	},

	/* Action for selecting a day. */
	_selectDay: function(id, month, year, td) {
		var target = $(id);
		if ($(td).hasClass(this._unselectableClass) || this._isDisabledDatepicker(target[0])) {
			return;
		}
		var inst = this._getInst(target[0]);
		inst.selectedDay = inst.currentDay = $('a', td).html();
		inst.selectedMonth = inst.currentMonth = month;
		inst.selectedYear = inst.currentYear = year;
		if (inst.stayOpen) {
			inst.endDay = inst.endMonth = inst.endYear = null;
		}
		this._selectDate(id, this._formatDate(inst,
			inst.currentDay, inst.currentMonth, inst.currentYear));
		if (inst.stayOpen) {
			inst.rangeStart = this._daylightSavingAdjust(
				new Date(inst.currentYear, inst.currentMonth, inst.currentDay));
			this._updateDatepicker(inst);
		}
	},

	/* Erase the input field and hide the date picker. */
	_clearDate: function(id) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		inst.stayOpen = false;
		inst.endDay = inst.endMonth = inst.endYear = inst.rangeStart = null;
		this._selectDate(target, '');
	},

	/* Update the input field with the selected date. */
	_selectDate: function(id, dateStr) {
		var target = $(id);
		var inst = this._getInst(target[0]);
		dateStr = (dateStr != null ? dateStr : this._formatDate(inst));
		if (inst.input)
			inst.input.val(dateStr);
		this._updateAlternate(inst);
		var onSelect = this._get(inst, 'onSelect');
		if (onSelect)
			onSelect.apply((inst.input ? inst.input[0] : null), [dateStr, inst]);  // trigger custom callback
		else if (inst.input)
			inst.input.trigger('change'); // fire the change event
		if (inst.inline)
			this._updateDatepicker(inst);
		else if (!inst.stayOpen) {
			this._hideDatepicker(null, this._get(inst, 'duration'));
			this._lastInput = inst.input[0];
			if (typeof(inst.input[0]) != 'object')
				inst.input[0].focus(); // restore focus
			this._lastInput = null;
		}
	},

	/* Update any alternate field to synchronise with the main field. */
	_updateAlternate: function(inst) {
		var altField = this._get(inst, 'altField');
		if (altField) { // update alternate field too
			var altFormat = this._get(inst, 'altFormat') || this._get(inst, 'dateFormat');
			var date = this._getDate(inst);
			dateStr = this.formatDate(altFormat, date, this._getFormatConfig(inst));
			$(altField).each(function() { $(this).val(dateStr); });
		}
	},

	/* Set as beforeShowDay function to prevent selection of weekends.
	   @param  date  Date - the date to customise
	   @return [boolean, string] - is this date selectable?, what is its CSS class? */
	noWeekends: function(date) {
		var day = date.getDay();
		return [(day > 0 && day < 6), ''];
	},

	/* Set as calculateWeek to determine the week of the year based on the ISO 8601 definition.
	   @param  date  Date - the date to get the week for
	   @return  number - the number of the week within the year that contains this date */
	iso8601Week: function(date) {
		var checkDate = new Date(date.getFullYear(), date.getMonth(), date.getDate());
		var firstMon = new Date(checkDate.getFullYear(), 1 - 1, 4); // First week always contains 4 Jan
		var firstDay = firstMon.getDay() || 7; // Day of week: Mon = 1, ..., Sun = 7
		firstMon.setDate(firstMon.getDate() + 1 - firstDay); // Preceding Monday
		if (firstDay < 4 && checkDate < firstMon) { // Adjust first three days in year if necessary
			checkDate.setDate(checkDate.getDate() - 3); // Generate for previous year
			return $.datepicker.iso8601Week(checkDate);
		} else if (checkDate > new Date(checkDate.getFullYear(), 12 - 1, 28)) { // Check last three days in year
			firstDay = new Date(checkDate.getFullYear() + 1, 1 - 1, 4).getDay() || 7;
			if (firstDay > 4 && (checkDate.getDay() || 7) < firstDay - 3) { // Adjust if necessary
				return 1;
			}
		}
		return Math.floor(((checkDate - firstMon) / 86400000) / 7) + 1; // Weeks to given date
	},

	/* Parse a string value into a date object.
	   See formatDate below for the possible formats.

	   @param  format    string - the expected format of the date
	   @param  value     string - the date in the above format
	   @param  settings  Object - attributes include:
	                     shortYearCutoff  number - the cutoff year for determining the century (optional)
	                     dayNamesShort    string[7] - abbreviated names of the days from Sunday (optional)
	                     dayNames         string[7] - names of the days from Sunday (optional)
	                     monthNamesShort  string[12] - abbreviated names of the months (optional)
	                     monthNames       string[12] - names of the months (optional)
	   @return  Date - the extracted date value or null if value is blank */
	parseDate: function (format, value, settings) {
		if (format == null || value == null)
			throw 'Invalid arguments';
		value = (typeof value == 'object' ? value.toString() : value + '');
		if (value == '')
			return null;
		var shortYearCutoff = (settings ? settings.shortYearCutoff : null) || this._defaults.shortYearCutoff;
		var dayNamesShort = (settings ? settings.dayNamesShort : null) || this._defaults.dayNamesShort;
		var dayNames = (settings ? settings.dayNames : null) || this._defaults.dayNames;
		var monthNamesShort = (settings ? settings.monthNamesShort : null) || this._defaults.monthNamesShort;
		var monthNames = (settings ? settings.monthNames : null) || this._defaults.monthNames;
		var year = -1;
		var month = -1;
		var day = -1;
		var doy = -1;
		var literal = false;
		var lookAhead = function(match) {
			var matches = (iFormat + 1 < format.length && format.charAt(iFormat + 1) == match);
			if (matches)
				iFormat++;
			return matches;
		};
		var getNumber = function(match) {
			lookAhead(match);
			var origSize = (match == '@' ? 14 : (match == 'y' ? 4 : (match == 'o' ? 3 : 2)));
			var size = origSize;
			var num = 0;
			while (size > 0 && iValue < value.length &&
					value.charAt(iValue) >= '0' && value.charAt(iValue) <= '9') {
				num = num * 10 + parseInt(value.charAt(iValue++),10);
				size--;
			}
			if (size == origSize)
				throw 'Missing number at position ' + iValue;
			return num;
		};
		var getName = function(match, shortNames, longNames) {
			var names = (lookAhead(match) ? longNames : shortNames);
			var size = 0;
			for (var j = 0; j < names.length; j++)
				size = Math.max(size, names[j].length);
			var name = '';
			var iInit = iValue;
			while (size > 0 && iValue < value.length) {
				name += value.charAt(iValue++);
				for (var i = 0; i < names.length; i++)
					if (name == names[i])
						return i + 1;
				size--;
			}
			throw 'Unknown name at position ' + iInit;
		};
		var checkLiteral = function() {
			if (value.charAt(iValue) != format.charAt(iFormat))
				throw 'Unexpected literal at position ' + iValue;
			iValue++;
		};
		var iValue = 0;
		for (var iFormat = 0; iFormat < format.length; iFormat++) {
			if (literal)
				if (format.charAt(iFormat) == "'" && !lookAhead("'"))
					literal = false;
				else
					checkLiteral();
			else
				switch (format.charAt(iFormat)) {
					case 'd':
						day = getNumber('d');
						break;
					case 'D':
						getName('D', dayNamesShort, dayNames);
						break;
					case 'o':
						doy = getNumber('o');
						break;
					case 'm':
						month = getNumber('m');
						break;
					case 'M':
						month = getName('M', monthNamesShort, monthNames);
						break;
					case 'y':
						year = getNumber('y');
						break;
					case '@':
						var date = new Date(getNumber('@'));
						year = date.getFullYear();
						month = date.getMonth() + 1;
						day = date.getDate();
						break;
					case "'":
						if (lookAhead("'"))
							checkLiteral();
						else
							literal = true;
						break;
					default:
						checkLiteral();
				}
		}
		if (year == -1)
			year = new Date().getFullYear();
		else if (year < 100)
			year += new Date().getFullYear() - new Date().getFullYear() % 100 +
				(year <= shortYearCutoff ? 0 : -100);
		if (doy > -1) {
			month = 1;
			day = doy;
			do {
				var dim = this._getDaysInMonth(year, month - 1);
				if (day <= dim)
					break;
				month++;
				day -= dim;
			} while (true);
		}
		var date = this._daylightSavingAdjust(new Date(year, month - 1, day));
		if (date.getFullYear() != year || date.getMonth() + 1 != month || date.getDate() != day)
			throw 'Invalid date'; // E.g. 31/02/*
		return date;
	},

	/* Standard date formats. */
	ATOM: 'yy-mm-dd', // RFC 3339 (ISO 8601)
	COOKIE: 'D, dd M yy',
	ISO_8601: 'yy-mm-dd',
	RFC_822: 'D, d M y',
	RFC_850: 'DD, dd-M-y',
	RFC_1036: 'D, d M y',
	RFC_1123: 'D, d M yy',
	RFC_2822: 'D, d M yy',
	RSS: 'D, d M y', // RFC 822
	TIMESTAMP: '@',
	W3C: 'yy-mm-dd', // ISO 8601

	/* Format a date object into a string value.
	   The format can be combinations of the following:
	   d  - day of month (no leading zero)
	   dd - day of month (two digit)
	   o  - day of year (no leading zeros)
	   oo - day of year (three digit)
	   D  - day name short
	   DD - day name long
	   m  - month of year (no leading zero)
	   mm - month of year (two digit)
	   M  - month name short
	   MM - month name long
	   y  - year (two digit)
	   yy - year (four digit)
	   @ - Unix timestamp (ms since 01/01/1970)
	   '...' - literal text
	   '' - single quote

	   @param  format    string - the desired format of the date
	   @param  date      Date - the date value to format
	   @param  settings  Object - attributes include:
	                     dayNamesShort    string[7] - abbreviated names of the days from Sunday (optional)
	                     dayNames         string[7] - names of the days from Sunday (optional)
	                     monthNamesShort  string[12] - abbreviated names of the months (optional)
	                     monthNames       string[12] - names of the months (optional)
	   @return  string - the date in the above format */
	formatDate: function (format, date, settings) {
		if (!date)
			return '';
		var dayNamesShort = (settings ? settings.dayNamesShort : null) || this._defaults.dayNamesShort;
		var dayNames = (settings ? settings.dayNames : null) || this._defaults.dayNames;
		var monthNamesShort = (settings ? settings.monthNamesShort : null) || this._defaults.monthNamesShort;
		var monthNames = (settings ? settings.monthNames : null) || this._defaults.monthNames;
		var lookAhead = function(match) {
			var matches = (iFormat + 1 < format.length && format.charAt(iFormat + 1) == match);
			if (matches)
				iFormat++;
			return matches;
		};
		var formatNumber = function(match, value, len) {
			var num = '' + value;
			if (lookAhead(match))
				while (num.length < len)
					num = '0' + num;
			return num;
		};
		var formatName = function(match, value, shortNames, longNames) {
			return (lookAhead(match) ? longNames[value] : shortNames[value]);
		};
		var output = '';
		var literal = false;
		if (date)
			for (var iFormat = 0; iFormat < format.length; iFormat++) {
				if (literal)
					if (format.charAt(iFormat) == "'" && !lookAhead("'"))
						literal = false;
					else
						output += format.charAt(iFormat);
				else
					switch (format.charAt(iFormat)) {
						case 'd':
							output += formatNumber('d', date.getDate(), 2);
							break;
						case 'D':
							output += formatName('D', date.getDay(), dayNamesShort, dayNames);
							break;
						case 'o':
							var doy = date.getDate();
							for (var m = date.getMonth() - 1; m >= 0; m--)
								doy += this._getDaysInMonth(date.getFullYear(), m);
							output += formatNumber('o', doy, 3);
							break;
						case 'm':
							output += formatNumber('m', date.getMonth() + 1, 2);
							break;
						case 'M':
							output += formatName('M', date.getMonth(), monthNamesShort, monthNames);
							break;
						case 'y':
							output += (lookAhead('y') ? date.getFullYear() :
								(date.getYear() % 100 < 10 ? '0' : '') + date.getYear() % 100);
							break;
						case '@':
							output += date.getTime();
							break;
						case "'":
							if (lookAhead("'"))
								output += "'";
							else
								literal = true;
							break;
						default:
							output += format.charAt(iFormat);
					}
			}
		return output;
	},

	/* Extract all possible characters from the date format. */
	_possibleChars: function (format) {
		var chars = '';
		var literal = false;
		for (var iFormat = 0; iFormat < format.length; iFormat++)
			if (literal)
				if (format.charAt(iFormat) == "'" && !lookAhead("'"))
					literal = false;
				else
					chars += format.charAt(iFormat);
			else
				switch (format.charAt(iFormat)) {
					case 'd': case 'm': case 'y': case '@':
						chars += '0123456789';
						break;
					case 'D': case 'M':
						return null; // Accept anything
					case "'":
						if (lookAhead("'"))
							chars += "'";
						else
							literal = true;
						break;
					default:
						chars += format.charAt(iFormat);
				}
		return chars;
	},

	/* Get a setting value, defaulting if necessary. */
	_get: function(inst, name) {
		return inst.settings[name] !== undefined ?
			inst.settings[name] : this._defaults[name];
	},

	/* Parse existing date and initialise date picker. */
	_setDateFromField: function(inst) {
		var dateFormat = this._get(inst, 'dateFormat');
		var dates = inst.input ? inst.input.val() : null;
		inst.endDay = inst.endMonth = inst.endYear = null;
		var date = defaultDate = this._getDefaultDate(inst);
		var settings = this._getFormatConfig(inst);
		try {
			date = this.parseDate(dateFormat, dates, settings) || defaultDate;
		} catch (event) {
			this.log(event);
			date = defaultDate;
		}
		inst.selectedDay = date.getDate();
		inst.drawMonth = inst.selectedMonth = date.getMonth();
		inst.drawYear = inst.selectedYear = date.getFullYear();
		inst.currentDay = (dates ? date.getDate() : 0);
		inst.currentMonth = (dates ? date.getMonth() : 0);
		inst.currentYear = (dates ? date.getFullYear() : 0);
		this._adjustInstDate(inst);
	},

	/* Retrieve the default date shown on opening. */
	_getDefaultDate: function(inst) {
		var date = this._determineDate(this._get(inst, 'defaultDate'), new Date());
		var minDate = this._getMinMaxDate(inst, 'min', true);
		var maxDate = this._getMinMaxDate(inst, 'max');
		date = (minDate && date < minDate ? minDate : date);
		date = (maxDate && date > maxDate ? maxDate : date);
		return date;
	},

	/* A date may be specified as an exact value or a relative one. */
	_determineDate: function(date, defaultDate) {
		var offsetNumeric = function(offset) {
			var date = new Date();
			date.setDate(date.getDate() + offset);
			return date;
		};
		var offsetString = function(offset, getDaysInMonth) {
			var date = new Date();
			var year = date.getFullYear();
			var month = date.getMonth();
			var day = date.getDate();
			var pattern = /([+-]?[0-9]+)\s*(d|D|w|W|m|M|y|Y)?/g;
			var matches = pattern.exec(offset);
			while (matches) {
				switch (matches[2] || 'd') {
					case 'd' : case 'D' :
						day += parseInt(matches[1],10); break;
					case 'w' : case 'W' :
						day += parseInt(matches[1],10) * 7; break;
					case 'm' : case 'M' :
						month += parseInt(matches[1],10);
						day = Math.min(day, getDaysInMonth(year, month));
						break;
					case 'y': case 'Y' :
						year += parseInt(matches[1],10);
						day = Math.min(day, getDaysInMonth(year, month));
						break;
				}
				matches = pattern.exec(offset);
			}
			return new Date(year, month, day);
		};
		date = (date == null ? defaultDate :
			(typeof date == 'string' ? offsetString(date, this._getDaysInMonth) :
			(typeof date == 'number' ? (isNaN(date) ? defaultDate : offsetNumeric(date)) : date)));
		date = (date && date.toString() == 'Invalid Date' ? defaultDate : date);
		if (date) {
			date.setHours(0);
			date.setMinutes(0);
			date.setSeconds(0);
			date.setMilliseconds(0);
		}
		return this._daylightSavingAdjust(date);
	},

	/* Handle switch to/from daylight saving.
	   Hours may be non-zero on daylight saving cut-over:
	   > 12 when midnight changeover, but then cannot generate
	   midnight datetime, so jump to 1AM, otherwise reset.
	   @param  date  (Date) the date to check
	   @return  (Date) the corrected date */
	_daylightSavingAdjust: function(date) {
		if (!date) return null;
		date.setHours(date.getHours() > 12 ? date.getHours() + 2 : 0);
		return date;
	},

	/* Set the date(s) directly. */
	_setDate: function(inst, date, endDate) {
		var clear = !(date);
		var origMonth = inst.selectedMonth;
		var origYear = inst.selectedYear;
		date = this._determineDate(date, new Date());
		inst.selectedDay = inst.currentDay = date.getDate();
		inst.drawMonth = inst.selectedMonth = inst.currentMonth = date.getMonth();
		inst.drawYear = inst.selectedYear = inst.currentYear = date.getFullYear();
		if (origMonth != inst.selectedMonth || origYear != inst.selectedYear)
			this._notifyChange(inst);
		this._adjustInstDate(inst);
		if (inst.input) {
			inst.input.val(clear ? '' : this._formatDate(inst));
		}
	},

	/* Retrieve the date(s) directly. */
	_getDate: function(inst) {
		var startDate = (!inst.currentYear || (inst.input && inst.input.val() == '') ? null :
			this._daylightSavingAdjust(new Date(
			inst.currentYear, inst.currentMonth, inst.currentDay)));
			return startDate;
	},

	/* Generate the HTML for the current state of the date picker. */
	_generateHTML: function(inst) {
		var today = new Date();
		today = this._daylightSavingAdjust(
			new Date(today.getFullYear(), today.getMonth(), today.getDate())); // clear time
		var isRTL = this._get(inst, 'isRTL');
		var showButtonPanel = this._get(inst, 'showButtonPanel');
		var hideIfNoPrevNext = this._get(inst, 'hideIfNoPrevNext');
		var navigationAsDateFormat = this._get(inst, 'navigationAsDateFormat');
		var numMonths = this._getNumberOfMonths(inst);
		var showCurrentAtPos = this._get(inst, 'showCurrentAtPos');
		var stepMonths = this._get(inst, 'stepMonths');
		var stepBigMonths = this._get(inst, 'stepBigMonths');
		var isMultiMonth = (numMonths[0] != 1 || numMonths[1] != 1);
		var currentDate = this._daylightSavingAdjust((!inst.currentDay ? new Date(9999, 9, 9) :
			new Date(inst.currentYear, inst.currentMonth, inst.currentDay)));
		var minDate = this._getMinMaxDate(inst, 'min', true);
		var maxDate = this._getMinMaxDate(inst, 'max');
		var drawMonth = inst.drawMonth - showCurrentAtPos;
		var drawYear = inst.drawYear;
		if (drawMonth < 0) {
			drawMonth += 12;
			drawYear--;
		}
		if (maxDate) {
			var maxDraw = this._daylightSavingAdjust(new Date(maxDate.getFullYear(),
				maxDate.getMonth() - numMonths[1] + 1, maxDate.getDate()));
			maxDraw = (minDate && maxDraw < minDate ? minDate : maxDraw);
			while (this._daylightSavingAdjust(new Date(drawYear, drawMonth, 1)) > maxDraw) {
				drawMonth--;
				if (drawMonth < 0) {
					drawMonth = 11;
					drawYear--;
				}
			}
		}
		inst.drawMonth = drawMonth;
		inst.drawYear = drawYear;
		var prevText = this._get(inst, 'prevText');
		prevText = (!navigationAsDateFormat ? prevText : this.formatDate(prevText,
			this._daylightSavingAdjust(new Date(drawYear, drawMonth - stepMonths, 1)),
			this._getFormatConfig(inst)));
		var prev = (this._canAdjustMonth(inst, -1, drawYear, drawMonth) ?
			'<a class="ui-datepicker-prev ui-corner-all" onclick="DP_jQuery.datepicker._adjustDate(\'#' + inst.id + '\', -' + stepMonths + ', \'M\');"' +
			' title="' + prevText + '"><span class="ui-icon ui-icon-circle-triangle-' + ( isRTL ? 'e' : 'w') + '">' + prevText + '</span></a>' :
			(hideIfNoPrevNext ? '' : '<a class="ui-datepicker-prev ui-corner-all ui-state-disabled" title="'+ prevText +'"><span class="ui-icon ui-icon-circle-triangle-' + ( isRTL ? 'e' : 'w') + '">' + prevText + '</span></a>'));
		var nextText = this._get(inst, 'nextText');
		nextText = (!navigationAsDateFormat ? nextText : this.formatDate(nextText,
			this._daylightSavingAdjust(new Date(drawYear, drawMonth + stepMonths, 1)),
			this._getFormatConfig(inst)));
		var next = (this._canAdjustMonth(inst, +1, drawYear, drawMonth) ?
			'<a class="ui-datepicker-next ui-corner-all" onclick="DP_jQuery.datepicker._adjustDate(\'#' + inst.id + '\', +' + stepMonths + ', \'M\');"' +
			' title="' + nextText + '"><span class="ui-icon ui-icon-circle-triangle-' + ( isRTL ? 'w' : 'e') + '">' + nextText + '</span></a>' :
			(hideIfNoPrevNext ? '' : '<a class="ui-datepicker-next ui-corner-all ui-state-disabled" title="'+ nextText + '"><span class="ui-icon ui-icon-circle-triangle-' + ( isRTL ? 'w' : 'e') + '">' + nextText + '</span></a>'));
		var currentText = this._get(inst, 'currentText');
		var gotoDate = (this._get(inst, 'gotoCurrent') && inst.currentDay ? currentDate : today);
		currentText = (!navigationAsDateFormat ? currentText :
			this.formatDate(currentText, gotoDate, this._getFormatConfig(inst)));
		var controls = (!inst.inline ? '<button type="button" class="ui-datepicker-close ui-state-default ui-priority-primary ui-corner-all" onclick="DP_jQuery.datepicker._hideDatepicker();">' + this._get(inst, 'closeText') + '</button>' : '');
		var buttonPanel = (showButtonPanel) ? '<div class="ui-datepicker-buttonpane ui-widget-content">' + (isRTL ? controls : '') +
			(this._isInRange(inst, gotoDate) ? '<button type="button" class="ui-datepicker-current ui-state-default ui-priority-secondary ui-corner-all" onclick="DP_jQuery.datepicker._gotoToday(\'#' + inst.id + '\');"' +
			'>' + currentText + '</button>' : '') + (isRTL ? '' : controls) + '</div>' : '';
		var firstDay = parseInt(this._get(inst, 'firstDay'),10);
		firstDay = (isNaN(firstDay) ? 0 : firstDay);
		var dayNames = this._get(inst, 'dayNames');
		var dayNamesShort = this._get(inst, 'dayNamesShort');
		var dayNamesMin = this._get(inst, 'dayNamesMin');
		var monthNames = this._get(inst, 'monthNames');
		var monthNamesShort = this._get(inst, 'monthNamesShort');
		var beforeShowDay = this._get(inst, 'beforeShowDay');
		var showOtherMonths = this._get(inst, 'showOtherMonths');
		var calculateWeek = this._get(inst, 'calculateWeek') || this.iso8601Week;
		var endDate = inst.endDay ? this._daylightSavingAdjust(
			new Date(inst.endYear, inst.endMonth, inst.endDay)) : currentDate;
		var defaultDate = this._getDefaultDate(inst);
		var html = '';
		for (var row = 0; row < numMonths[0]; row++) {
			var group = '';
			for (var col = 0; col < numMonths[1]; col++) {
				var selectedDate = this._daylightSavingAdjust(new Date(drawYear, drawMonth, inst.selectedDay));
				var cornerClass = ' ui-corner-all';
				var calender = '';
				if (isMultiMonth) {
					calender += '<div class="ui-datepicker-group ui-datepicker-group-';
					switch (col) {
						case 0: calender += 'first'; cornerClass = ' ui-corner-' + (isRTL ? 'right' : 'left'); break;
						case numMonths[1]-1: calender += 'last'; cornerClass = ' ui-corner-' + (isRTL ? 'left' : 'right'); break;
						default: calender += 'middle'; cornerClass = ''; break;
					}
					calender += '">';
				}
				calender += '<div class="ui-datepicker-header ui-widget-header ui-helper-clearfix' + cornerClass + '">' +
					(/all|left/.test(cornerClass) && row == 0 ? (isRTL ? next : prev) : '') +
					(/all|right/.test(cornerClass) && row == 0 ? (isRTL ? prev : next) : '') +
					this._generateMonthYearHeader(inst, drawMonth, drawYear, minDate, maxDate,
					selectedDate, row > 0 || col > 0, monthNames, monthNamesShort) + // draw month headers
					'</div><table class="ui-datepicker-calendar"><thead>' +
					'<tr>';
				var thead = '';
				for (var dow = 0; dow < 7; dow++) { // days of the week
					var day = (dow + firstDay) % 7;
					thead += '<th' + ((dow + firstDay + 6) % 7 >= 5 ? ' class="ui-datepicker-week-end"' : '') + '>' +
						'<span title="' + dayNames[day] + '">' + dayNamesMin[day] + '</span></th>';
				}
				calender += thead + '</tr></thead><tbody>';
				var daysInMonth = this._getDaysInMonth(drawYear, drawMonth);
				if (drawYear == inst.selectedYear && drawMonth == inst.selectedMonth)
					inst.selectedDay = Math.min(inst.selectedDay, daysInMonth);
				var leadDays = (this._getFirstDayOfMonth(drawYear, drawMonth) - firstDay + 7) % 7;
				var numRows = (isMultiMonth ? 6 : Math.ceil((leadDays + daysInMonth) / 7)); // calculate the number of rows to generate
				var printDate = this._daylightSavingAdjust(new Date(drawYear, drawMonth, 1 - leadDays));
				for (var dRow = 0; dRow < numRows; dRow++) { // create date picker rows
					calender += '<tr>';
					var tbody = '';
					for (var dow = 0; dow < 7; dow++) { // create date picker days
						var daySettings = (beforeShowDay ?
							beforeShowDay.apply((inst.input ? inst.input[0] : null), [printDate]) : [true, '']);
						var otherMonth = (printDate.getMonth() != drawMonth);
						var unselectable = otherMonth || !daySettings[0] ||
							(minDate && printDate < minDate) || (maxDate && printDate > maxDate);
						tbody += '<td class="' +
							((dow + firstDay + 6) % 7 >= 5 ? ' ui-datepicker-week-end' : '') + // highlight weekends
							(otherMonth ? ' ui-datepicker-other-month' : '') + // highlight days from other months
							((printDate.getTime() == selectedDate.getTime() && drawMonth == inst.selectedMonth && inst._keyEvent) || // user pressed key
							(defaultDate.getTime() == printDate.getTime() && defaultDate.getTime() == selectedDate.getTime()) ?
							' ' + this._dayOverClass : '') + // highlight selected day
							(unselectable ? ' ' + this._unselectableClass + ' ui-state-disabled': '') +  // highlight unselectable days
							(otherMonth && !showOtherMonths ? '' : ' ' + daySettings[1] + // highlight custom dates
							(printDate.getTime() >= currentDate.getTime() && printDate.getTime() <= endDate.getTime() ? // in current range
							' ' + this._currentClass : '') + // highlight selected day
							(printDate.getTime() == today.getTime() ? ' ui-datepicker-today' : '')) + '"' + // highlight today (if different)
							((!otherMonth || showOtherMonths) && daySettings[2] ? ' title="' + daySettings[2] + '"' : '') + // cell title
							(unselectable ? '' : ' onclick="DP_jQuery.datepicker._selectDay(\'#' +
							inst.id + '\',' + drawMonth + ',' + drawYear + ', this);return false;"') + '>' + // actions
							(otherMonth ? (showOtherMonths ? printDate.getDate() : '&#xa0;') : // display for other months
							(unselectable ? '<span class="ui-state-default">' + printDate.getDate() + '</span>' : '<a class="ui-state-default' +
							(printDate.getTime() == today.getTime() ? ' ui-state-highlight' : '') +
							(printDate.getTime() >= currentDate.getTime() && printDate.getTime() <= endDate.getTime() ? // in current range
							' ui-state-active' : '') + // highlight selected day
							'" href="#">' + printDate.getDate() + '</a>')) + '</td>'; // display for this month
						printDate.setDate(printDate.getDate() + 1);
						printDate = this._daylightSavingAdjust(printDate);
					}
					calender += tbody + '</tr>';
				}
				drawMonth++;
				if (drawMonth > 11) {
					drawMonth = 0;
					drawYear++;
				}
				calender += '</tbody></table>' + (isMultiMonth ? '</div>' +
							((numMonths[0] > 0 && col == numMonths[1]-1) ? '<div class="ui-datepicker-row-break"></div>' : '') : '');
				group += calender;
			}
			html += group;
		}
		html += buttonPanel + ($.browser.msie && parseInt($.browser.version,10) < 7 && !inst.inline ?
			'<iframe src="javascript:false;" class="ui-datepicker-cover" frameborder="0"></iframe>' : '');
		inst._keyEvent = false;
		return html;
	},

	/* Generate the month and year header. */
	_generateMonthYearHeader: function(inst, drawMonth, drawYear, minDate, maxDate,
			selectedDate, secondary, monthNames, monthNamesShort) {
		minDate = (inst.rangeStart && minDate && selectedDate < minDate ? selectedDate : minDate);
		var changeMonth = this._get(inst, 'changeMonth');
		var changeYear = this._get(inst, 'changeYear');
		var showMonthAfterYear = this._get(inst, 'showMonthAfterYear');
		var html = '<div class="ui-datepicker-title">';
		var monthHtml = '';
		if (secondary || !changeMonth)
			monthHtml += '<span class="ui-datepicker-month">' + monthNames[drawMonth] + '</span> ';
		else {
			var inMinYear = (minDate && minDate.getFullYear() == drawYear);
			var inMaxYear = (maxDate && maxDate.getFullYear() == drawYear);
			monthHtml += '<select class="ui-datepicker-month" ' +
				'onchange="DP_jQuery.datepicker._selectMonthYear(\'#' + inst.id + '\', this, \'M\');" ' +
				'onclick="DP_jQuery.datepicker._clickMonthYear(\'#' + inst.id + '\');"' +
			 	'>';
			for (var month = 0; month < 12; month++) {
				if ((!inMinYear || month >= minDate.getMonth()) &&
						(!inMaxYear || month <= maxDate.getMonth()))
					monthHtml += '<option value="' + month + '"' +
						(month == drawMonth ? ' selected="selected"' : '') +
						'>' + monthNamesShort[month] + '</option>';
			}
			monthHtml += '</select>';
		}
		if (!showMonthAfterYear)
			html += monthHtml + ((secondary || changeMonth || changeYear) && (!(changeMonth && changeYear)) ? '&#xa0;' : '');
		if (secondary || !changeYear)
			html += '<span class="ui-datepicker-year">' + drawYear + '</span>';
		else {
			var years = this._get(inst, 'yearRange').split(':');
			var year = 0;
			var endYear = 0;
			if (years.length != 2) {
				year = drawYear - 10;
				endYear = drawYear + 10;
			} else if (years[0].charAt(0) == '+' || years[0].charAt(0) == '-') {
				year = drawYear + parseInt(years[0], 10);
				endYear = drawYear + parseInt(years[1], 10);
			} else {
				year = parseInt(years[0], 10);
				endYear = parseInt(years[1], 10);
			}
			year = (minDate ? Math.max(year, minDate.getFullYear()) : year);
			endYear = (maxDate ? Math.min(endYear, maxDate.getFullYear()) : endYear);
			html += '<select class="ui-datepicker-year" ' +
				'onchange="DP_jQuery.datepicker._selectMonthYear(\'#' + inst.id + '\', this, \'Y\');" ' +
				'onclick="DP_jQuery.datepicker._clickMonthYear(\'#' + inst.id + '\');"' +
				'>';
			for (; year <= endYear; year++) {
				html += '<option value="' + year + '"' +
					(year == drawYear ? ' selected="selected"' : '') +
					'>' + year + '</option>';
			}
			html += '</select>';
		}
		if (showMonthAfterYear)
			html += (secondary || changeMonth || changeYear ? '&#xa0;' : '') + monthHtml;
		html += '</div>'; // Close datepicker_header
		return html;
	},

	/* Adjust one of the date sub-fields. */
	_adjustInstDate: function(inst, offset, period) {
		var year = inst.drawYear + (period == 'Y' ? offset : 0);
		var month = inst.drawMonth + (period == 'M' ? offset : 0);
		var day = Math.min(inst.selectedDay, this._getDaysInMonth(year, month)) +
			(period == 'D' ? offset : 0);
		var date = this._daylightSavingAdjust(new Date(year, month, day));
		var minDate = this._getMinMaxDate(inst, 'min', true);
		var maxDate = this._getMinMaxDate(inst, 'max');
		date = (minDate && date < minDate ? minDate : date);
		date = (maxDate && date > maxDate ? maxDate : date);
		inst.selectedDay = date.getDate();
		inst.drawMonth = inst.selectedMonth = date.getMonth();
		inst.drawYear = inst.selectedYear = date.getFullYear();
		if (period == 'M' || period == 'Y')
			this._notifyChange(inst);
	},

	/* Notify change of month/year. */
	_notifyChange: function(inst) {
		var onChange = this._get(inst, 'onChangeMonthYear');
		if (onChange)
			onChange.apply((inst.input ? inst.input[0] : null),
				[inst.selectedYear, inst.selectedMonth + 1, inst]);
	},

	/* Determine the number of months to show. */
	_getNumberOfMonths: function(inst) {
		var numMonths = this._get(inst, 'numberOfMonths');
		return (numMonths == null ? [1, 1] : (typeof numMonths == 'number' ? [1, numMonths] : numMonths));
	},

	/* Determine the current maximum date - ensure no time components are set - may be overridden for a range. */
	_getMinMaxDate: function(inst, minMax, checkRange) {
		var date = this._determineDate(this._get(inst, minMax + 'Date'), null);
		return (!checkRange || !inst.rangeStart ? date :
			(!date || inst.rangeStart > date ? inst.rangeStart : date));
	},

	/* Find the number of days in a given month. */
	_getDaysInMonth: function(year, month) {
		return 32 - new Date(year, month, 32).getDate();
	},

	/* Find the day of the week of the first of a month. */
	_getFirstDayOfMonth: function(year, month) {
		return new Date(year, month, 1).getDay();
	},

	/* Determines if we should allow a "next/prev" month display change. */
	_canAdjustMonth: function(inst, offset, curYear, curMonth) {
		var numMonths = this._getNumberOfMonths(inst);
		var date = this._daylightSavingAdjust(new Date(
			curYear, curMonth + (offset < 0 ? offset : numMonths[1]), 1));
		if (offset < 0)
			date.setDate(this._getDaysInMonth(date.getFullYear(), date.getMonth()));
		return this._isInRange(inst, date);
	},

	/* Is the given date in the accepted range? */
	_isInRange: function(inst, date) {
		var newMinDate = (!inst.rangeStart ? null : this._daylightSavingAdjust(
			new Date(inst.selectedYear, inst.selectedMonth, inst.selectedDay)));
		newMinDate = (newMinDate && inst.rangeStart < newMinDate ? inst.rangeStart : newMinDate);
		var minDate = newMinDate || this._getMinMaxDate(inst, 'min');
		var maxDate = this._getMinMaxDate(inst, 'max');
		return ((!minDate || date >= minDate) && (!maxDate || date <= maxDate));
	},

	/* Provide the configuration settings for formatting/parsing. */
	_getFormatConfig: function(inst) {
		var shortYearCutoff = this._get(inst, 'shortYearCutoff');
		shortYearCutoff = (typeof shortYearCutoff != 'string' ? shortYearCutoff :
			new Date().getFullYear() % 100 + parseInt(shortYearCutoff, 10));
		return {shortYearCutoff: shortYearCutoff,
			dayNamesShort: this._get(inst, 'dayNamesShort'), dayNames: this._get(inst, 'dayNames'),
			monthNamesShort: this._get(inst, 'monthNamesShort'), monthNames: this._get(inst, 'monthNames')};
	},

	/* Format the given date for display. */
	_formatDate: function(inst, day, month, year) {
		if (!day) {
			inst.currentDay = inst.selectedDay;
			inst.currentMonth = inst.selectedMonth;
			inst.currentYear = inst.selectedYear;
		}
		var date = (day ? (typeof day == 'object' ? day :
			this._daylightSavingAdjust(new Date(year, month, day))) :
			this._daylightSavingAdjust(new Date(inst.currentYear, inst.currentMonth, inst.currentDay)));
		return this.formatDate(this._get(inst, 'dateFormat'), date, this._getFormatConfig(inst));
	}
});

/* jQuery extend now ignores nulls! */
function extendRemove(target, props) {
	$.extend(target, props);
	for (var name in props)
		if (props[name] == null || props[name] == undefined)
			target[name] = props[name];
	return target;
};

/* Determine whether an object is an array. */
function isArray(a) {
	return (a && (($.browser.safari && typeof a == 'object' && a.length) ||
		(a.constructor && a.constructor.toString().match(/\Array\(\)/))));
};

/* Invoke the datepicker functionality.
   @param  options  string - a command, optionally followed by additional parameters or
                    Object - settings for attaching new datepicker functionality
   @return  jQuery object */
$.fn.datepicker = function(options){

	/* Initialise the date picker. */
	if (!$.datepicker.initialized) {
		$(document).mousedown($.datepicker._checkExternalClick).
			find('body').append($.datepicker.dpDiv);
		$.datepicker.initialized = true;
	}

	var otherArgs = Array.prototype.slice.call(arguments, 1);
	if (typeof options == 'string' && (options == 'isDisabled' || options == 'getDate'))
		return $.datepicker['_' + options + 'Datepicker'].
			apply($.datepicker, [this[0]].concat(otherArgs));
	if (options == 'option' && arguments.length == 2 && typeof arguments[1] == 'string')
		return $.datepicker['_' + options + 'Datepicker'].
			apply($.datepicker, [this[0]].concat(otherArgs));
	return this.each(function() {
		typeof options == 'string' ?
			$.datepicker['_' + options + 'Datepicker'].
				apply($.datepicker, [this].concat(otherArgs)) :
			$.datepicker._attachDatepicker(this, options);
	});
};

$.datepicker = new Datepicker(); // singleton instance
$.datepicker.initialized = false;
$.datepicker.uuid = new Date().getTime();
$.datepicker.version = "1.7.2";

window.DP_jQuery = $;

})(jQuery);
/*
 * jQuery UI Progressbar 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Progressbar
 *
 * Depends:
 *   ui.core.js
 */
(function($) {

$.widget("ui.progressbar", {

	_init: function() {

		this.element
			.addClass("ui-progressbar"
				+ " ui-widget"
				+ " ui-widget-content"
				+ " ui-corner-all")
			.attr({
				role: "progressbar",
				"aria-valuemin": this._valueMin(),
				"aria-valuemax": this._valueMax(),
				"aria-valuenow": this._value()
			});

		this.valueDiv = $('<div class="ui-progressbar-value ui-widget-header ui-corner-left"></div>').appendTo(this.element);

		this._refreshValue();

	},

	destroy: function() {

		this.element
			.removeClass("ui-progressbar"
				+ " ui-widget"
				+ " ui-widget-content"
				+ " ui-corner-all")
			.removeAttr("role")
			.removeAttr("aria-valuemin")
			.removeAttr("aria-valuemax")
			.removeAttr("aria-valuenow")
			.removeData("progressbar")
			.unbind(".progressbar");

		this.valueDiv.remove();

		$.widget.prototype.destroy.apply(this, arguments);

	},

	value: function(newValue) {
		if (newValue === undefined) {
			return this._value();
		}

		this._setData('value', newValue);
		return this;
	},

	_setData: function(key, value) {

		switch (key) {
			case 'value':
				this.options.value = value;
				this._refreshValue();
				this._trigger('change', null, {});
				break;
		}

		$.widget.prototype._setData.apply(this, arguments);

	},

	_value: function() {

		var val = this.options.value;
		if (val < this._valueMin()) val = this._valueMin();
		if (val > this._valueMax()) val = this._valueMax();

		return val;

	},

	_valueMin: function() {
		var valueMin = 0;
		return valueMin;
	},

	_valueMax: function() {
		var valueMax = 100;
		return valueMax;
	},

	_refreshValue: function() {
		var value = this.value();
		this.valueDiv[value == this._valueMax() ? 'addClass' : 'removeClass']("ui-corner-right");
		this.valueDiv.width(value + '%');
		this.element.attr("aria-valuenow", value);
	}

});

$.extend($.ui.progressbar, {
	version: "1.7.2",
	defaults: {
		value: 0
	}
});

})(jQuery);
/*
 * jQuery UI Effects 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/
 */
;jQuery.effects || (function($) {

$.effects = {
	version: "1.7.2",

	save: function(element, set) {
		for(var i=0; i < set.length; i++) {
			if(set[i] !== null) element.data("ec.storage."+set[i], element[0].style[set[i]]);
		}
	},

	restore: function(element, set) {
		for(var i=0; i < set.length; i++) {
			if(set[i] !== null) element.css(set[i], element.data("ec.storage."+set[i]));
		}
	},

	setMode: function(el, mode) {
		if (mode == 'toggle') mode = el.is(':hidden') ? 'show' : 'hide'; // Set for toggle
		return mode;
	},

	getBaseline: function(origin, original) { // Translates a [top,left] array into a baseline value
		var y, x;
		switch (origin[0]) {
			case 'top': y = 0; break;
			case 'middle': y = 0.5; break;
			case 'bottom': y = 1; break;
			default: y = origin[0] / original.height;
		};
		switch (origin[1]) {
			case 'left': x = 0; break;
			case 'center': x = 0.5; break;
			case 'right': x = 1; break;
			default: x = origin[1] / original.width;
		};
		return {x: x, y: y};
	},

	createWrapper: function(element) {

		if (element.parent().is('.ui-effects-wrapper'))
			return element.parent();

		var props = { width: element.outerWidth(true), height: element.outerHeight(true), 'float': element.css('float') };
		element.wrap('<div class="ui-effects-wrapper" style="font-size:100%;background:transparent;border:none;margin:0;padding:0"></div>');
		var wrapper = element.parent();

		if (element.css('position') == 'static') {
			wrapper.css({ position: 'relative' });
			element.css({ position: 'relative'} );
		} else {
			var top = element.css('top'); if(isNaN(parseInt(top,10))) top = 'auto';
			var left = element.css('left'); if(isNaN(parseInt(left,10))) left = 'auto';
			wrapper.css({ position: element.css('position'), top: top, left: left, zIndex: element.css('z-index') }).show();
			element.css({position: 'relative', top: 0, left: 0 });
		}

		wrapper.css(props);
		return wrapper;
	},

	removeWrapper: function(element) {
		if (element.parent().is('.ui-effects-wrapper'))
			return element.parent().replaceWith(element);
		return element;
	},

	setTransition: function(element, list, factor, value) {
		value = value || {};
		$.each(list, function(i, x){
			unit = element.cssUnit(x);
			if (unit[0] > 0) value[x] = unit[0] * factor + unit[1];
		});
		return value;
	},

	animateClass: function(value, duration, easing, callback) {

		var cb = (typeof easing == "function" ? easing : (callback ? callback : null));
		var ea = (typeof easing == "string" ? easing : null);

		return this.each(function() {

			var offset = {}; var that = $(this); var oldStyleAttr = that.attr("style") || '';
			if(typeof oldStyleAttr == 'object') oldStyleAttr = oldStyleAttr["cssText"]; /* Stupidly in IE, style is a object.. */
			if(value.toggle) { that.hasClass(value.toggle) ? value.remove = value.toggle : value.add = value.toggle; }

			var oldStyle = $.extend({}, (document.defaultView ? document.defaultView.getComputedStyle(this,null) : this.currentStyle));
			if(value.add) that.addClass(value.add); if(value.remove) that.removeClass(value.remove);
			var newStyle = $.extend({}, (document.defaultView ? document.defaultView.getComputedStyle(this,null) : this.currentStyle));
			if(value.add) that.removeClass(value.add); if(value.remove) that.addClass(value.remove);

			for(var n in newStyle) {
				if( typeof newStyle[n] != "function" && newStyle[n] /* No functions and null properties */
				&& n.indexOf("Moz") == -1 && n.indexOf("length") == -1 /* No mozilla spezific render properties. */
				&& newStyle[n] != oldStyle[n] /* Only values that have changed are used for the animation */
				&& (n.match(/color/i) || (!n.match(/color/i) && !isNaN(parseInt(newStyle[n],10)))) /* Only things that can be parsed to integers or colors */
				&& (oldStyle.position != "static" || (oldStyle.position == "static" && !n.match(/left|top|bottom|right/))) /* No need for positions when dealing with static positions */
				) offset[n] = newStyle[n];
			}

			that.animate(offset, duration, ea, function() { // Animate the newly constructed offset object
				if(typeof $(this).attr("style") == 'object') { $(this).attr("style")["cssText"] = ""; $(this).attr("style")["cssText"] = oldStyleAttr; } else $(this).attr("style", oldStyleAttr);
				if(value.add) $(this).addClass(value.add); if(value.remove) $(this).removeClass(value.remove);
				if(cb) cb.apply(this, arguments);
			});

		});
	}
};


function _normalizeArguments(a, m) {

	var o = a[1] && a[1].constructor == Object ? a[1] : {}; if(m) o.mode = m;
	var speed = a[1] && a[1].constructor != Object ? a[1] : (o.duration ? o.duration : a[2]); //either comes from options.duration or the secon/third argument
		speed = $.fx.off ? 0 : typeof speed === "number" ? speed : $.fx.speeds[speed] || $.fx.speeds._default;
	var callback = o.callback || ( $.isFunction(a[1]) && a[1] ) || ( $.isFunction(a[2]) && a[2] ) || ( $.isFunction(a[3]) && a[3] );

	return [a[0], o, speed, callback];

}

$.fn.extend({

	_show: $.fn.show,
	_hide: $.fn.hide,
	__toggle: $.fn.toggle,
	_addClass: $.fn.addClass,
	_removeClass: $.fn.removeClass,
	_toggleClass: $.fn.toggleClass,

	effect: function(fx, options, speed, callback) {
		return $.effects[fx] ? $.effects[fx].call(this, {method: fx, options: options || {}, duration: speed, callback: callback }) : null;
	},

	show: function() {
		if(!arguments[0] || (arguments[0].constructor == Number || (/(slow|normal|fast)/).test(arguments[0])))
			return this._show.apply(this, arguments);
		else {
			return this.effect.apply(this, _normalizeArguments(arguments, 'show'));
		}
	},

	hide: function() {
		if(!arguments[0] || (arguments[0].constructor == Number || (/(slow|normal|fast)/).test(arguments[0])))
			return this._hide.apply(this, arguments);
		else {
			return this.effect.apply(this, _normalizeArguments(arguments, 'hide'));
		}
	},

	toggle: function(){
		if(!arguments[0] ||
			(arguments[0].constructor == Number || (/(slow|normal|fast)/).test(arguments[0])) ||
			($.isFunction(arguments[0]) || typeof arguments[0] == 'boolean')) {
			return this.__toggle.apply(this, arguments);
		} else {
			return this.effect.apply(this, _normalizeArguments(arguments, 'toggle'));
		}
	},

	addClass: function(classNames, speed, easing, callback) {
		return speed ? $.effects.animateClass.apply(this, [{ add: classNames },speed,easing,callback]) : this._addClass(classNames);
	},
	removeClass: function(classNames,speed,easing,callback) {
		return speed ? $.effects.animateClass.apply(this, [{ remove: classNames },speed,easing,callback]) : this._removeClass(classNames);
	},
	toggleClass: function(classNames,speed,easing,callback) {
		return ( (typeof speed !== "boolean") && speed ) ? $.effects.animateClass.apply(this, [{ toggle: classNames },speed,easing,callback]) : this._toggleClass(classNames, speed);
	},
	morph: function(remove,add,speed,easing,callback) {
		return $.effects.animateClass.apply(this, [{ add: add, remove: remove },speed,easing,callback]);
	},
	switchClass: function() {
		return this.morph.apply(this, arguments);
	},

	cssUnit: function(key) {
		var style = this.css(key), val = [];
		$.each( ['em','px','%','pt'], function(i, unit){
			if(style.indexOf(unit) > 0)
				val = [parseFloat(style), unit];
		});
		return val;
	}
});

/*
 * jQuery Color Animations
 * Copyright 2007 John Resig
 * Released under the MIT and GPL licenses.
 */

$.each(['backgroundColor', 'borderBottomColor', 'borderLeftColor', 'borderRightColor', 'borderTopColor', 'color', 'outlineColor'], function(i,attr){
		$.fx.step[attr] = function(fx) {
				if ( fx.state == 0 ) {
						fx.start = getColor( fx.elem, attr );
						fx.end = getRGB( fx.end );
				}

				fx.elem.style[attr] = "rgb(" + [
						Math.max(Math.min( parseInt((fx.pos * (fx.end[0] - fx.start[0])) + fx.start[0],10), 255), 0),
						Math.max(Math.min( parseInt((fx.pos * (fx.end[1] - fx.start[1])) + fx.start[1],10), 255), 0),
						Math.max(Math.min( parseInt((fx.pos * (fx.end[2] - fx.start[2])) + fx.start[2],10), 255), 0)
				].join(",") + ")";
			};
});


function getRGB(color) {
		var result;

		if ( color && color.constructor == Array && color.length == 3 )
				return color;

		if (result = /rgb\(\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*,\s*([0-9]{1,3})\s*\)/.exec(color))
				return [parseInt(result[1],10), parseInt(result[2],10), parseInt(result[3],10)];

		if (result = /rgb\(\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*,\s*([0-9]+(?:\.[0-9]+)?)\%\s*\)/.exec(color))
				return [parseFloat(result[1])*2.55, parseFloat(result[2])*2.55, parseFloat(result[3])*2.55];

		if (result = /#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})/.exec(color))
				return [parseInt(result[1],16), parseInt(result[2],16), parseInt(result[3],16)];

		if (result = /#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])/.exec(color))
				return [parseInt(result[1]+result[1],16), parseInt(result[2]+result[2],16), parseInt(result[3]+result[3],16)];

		if (result = /rgba\(0, 0, 0, 0\)/.exec(color))
				return colors['transparent'];

		return colors[$.trim(color).toLowerCase()];
}

function getColor(elem, attr) {
		var color;

		do {
				color = $.curCSS(elem, attr);

				if ( color != '' && color != 'transparent' || $.nodeName(elem, "body") )
						break;

				attr = "backgroundColor";
		} while ( elem = elem.parentNode );

		return getRGB(color);
};


var colors = {
	aqua:[0,255,255],
	azure:[240,255,255],
	beige:[245,245,220],
	black:[0,0,0],
	blue:[0,0,255],
	brown:[165,42,42],
	cyan:[0,255,255],
	darkblue:[0,0,139],
	darkcyan:[0,139,139],
	darkgrey:[169,169,169],
	darkgreen:[0,100,0],
	darkkhaki:[189,183,107],
	darkmagenta:[139,0,139],
	darkolivegreen:[85,107,47],
	darkorange:[255,140,0],
	darkorchid:[153,50,204],
	darkred:[139,0,0],
	darksalmon:[233,150,122],
	darkviolet:[148,0,211],
	fuchsia:[255,0,255],
	gold:[255,215,0],
	green:[0,128,0],
	indigo:[75,0,130],
	khaki:[240,230,140],
	lightblue:[173,216,230],
	lightcyan:[224,255,255],
	lightgreen:[144,238,144],
	lightgrey:[211,211,211],
	lightpink:[255,182,193],
	lightyellow:[255,255,224],
	lime:[0,255,0],
	magenta:[255,0,255],
	maroon:[128,0,0],
	navy:[0,0,128],
	olive:[128,128,0],
	orange:[255,165,0],
	pink:[255,192,203],
	purple:[128,0,128],
	violet:[128,0,128],
	red:[255,0,0],
	silver:[192,192,192],
	white:[255,255,255],
	yellow:[255,255,0],
	transparent: [255,255,255]
};

/*
 * jQuery Easing v1.3 - http://gsgd.co.uk/sandbox/jquery/easing/
 *
 * Uses the built in easing capabilities added In jQuery 1.1
 * to offer multiple easing options
 *
 * TERMS OF USE - jQuery Easing
 *
 * Open source under the BSD License.
 *
 * Copyright 2008 George McGinley Smith
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 *
 * Neither the name of the author nor the names of contributors may be used to endorse
 * or promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
*/

$.easing.jswing = $.easing.swing;

$.extend($.easing,
{
	def: 'easeOutQuad',
	swing: function (x, t, b, c, d) {
		return $.easing[$.easing.def](x, t, b, c, d);
	},
	easeInQuad: function (x, t, b, c, d) {
		return c*(t/=d)*t + b;
	},
	easeOutQuad: function (x, t, b, c, d) {
		return -c *(t/=d)*(t-2) + b;
	},
	easeInOutQuad: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t + b;
		return -c/2 * ((--t)*(t-2) - 1) + b;
	},
	easeInCubic: function (x, t, b, c, d) {
		return c*(t/=d)*t*t + b;
	},
	easeOutCubic: function (x, t, b, c, d) {
		return c*((t=t/d-1)*t*t + 1) + b;
	},
	easeInOutCubic: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t + b;
		return c/2*((t-=2)*t*t + 2) + b;
	},
	easeInQuart: function (x, t, b, c, d) {
		return c*(t/=d)*t*t*t + b;
	},
	easeOutQuart: function (x, t, b, c, d) {
		return -c * ((t=t/d-1)*t*t*t - 1) + b;
	},
	easeInOutQuart: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
		return -c/2 * ((t-=2)*t*t*t - 2) + b;
	},
	easeInQuint: function (x, t, b, c, d) {
		return c*(t/=d)*t*t*t*t + b;
	},
	easeOutQuint: function (x, t, b, c, d) {
		return c*((t=t/d-1)*t*t*t*t + 1) + b;
	},
	easeInOutQuint: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
		return c/2*((t-=2)*t*t*t*t + 2) + b;
	},
	easeInSine: function (x, t, b, c, d) {
		return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
	},
	easeOutSine: function (x, t, b, c, d) {
		return c * Math.sin(t/d * (Math.PI/2)) + b;
	},
	easeInOutSine: function (x, t, b, c, d) {
		return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
	},
	easeInExpo: function (x, t, b, c, d) {
		return (t==0) ? b : c * Math.pow(2, 10 * (t/d - 1)) + b;
	},
	easeOutExpo: function (x, t, b, c, d) {
		return (t==d) ? b+c : c * (-Math.pow(2, -10 * t/d) + 1) + b;
	},
	easeInOutExpo: function (x, t, b, c, d) {
		if (t==0) return b;
		if (t==d) return b+c;
		if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
		return c/2 * (-Math.pow(2, -10 * --t) + 2) + b;
	},
	easeInCirc: function (x, t, b, c, d) {
		return -c * (Math.sqrt(1 - (t/=d)*t) - 1) + b;
	},
	easeOutCirc: function (x, t, b, c, d) {
		return c * Math.sqrt(1 - (t=t/d-1)*t) + b;
	},
	easeInOutCirc: function (x, t, b, c, d) {
		if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
		return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
	},
	easeInElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return -(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
	},
	easeOutElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		return a*Math.pow(2,-10*t) * Math.sin( (t*d-s)*(2*Math.PI)/p ) + c + b;
	},
	easeInOutElastic: function (x, t, b, c, d) {
		var s=1.70158;var p=0;var a=c;
		if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
		if (a < Math.abs(c)) { a=c; var s=p/4; }
		else var s = p/(2*Math.PI) * Math.asin (c/a);
		if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
		return a*Math.pow(2,-10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )*.5 + c + b;
	},
	easeInBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
	},
	easeOutBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
	},
	easeInOutBack: function (x, t, b, c, d, s) {
		if (s == undefined) s = 1.70158;
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
	},
	easeInBounce: function (x, t, b, c, d) {
		return c - $.easing.easeOutBounce (x, d-t, 0, c, d) + b;
	},
	easeOutBounce: function (x, t, b, c, d) {
		if ((t/=d) < (1/2.75)) {
			return c*(7.5625*t*t) + b;
		} else if (t < (2/2.75)) {
			return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
		} else if (t < (2.5/2.75)) {
			return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
		} else {
			return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
		}
	},
	easeInOutBounce: function (x, t, b, c, d) {
		if (t < d/2) return $.easing.easeInBounce (x, t*2, 0, c, d) * .5 + b;
		return $.easing.easeOutBounce (x, t*2-d, 0, c, d) * .5 + c*.5 + b;
	}
});

/*
 *
 * TERMS OF USE - EASING EQUATIONS
 *
 * Open source under the BSD License.
 *
 * Copyright 2001 Robert Penner
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 *
 * Neither the name of the author nor the names of contributors may be used to endorse
 * or promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

})(jQuery);
/*
 * jQuery UI Effects Blind 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Blind
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.blind = function(o) {

	return this.queue(function() {

		var el = $(this), props = ['position','top','left'];

		var mode = $.effects.setMode(el, o.options.mode || 'hide'); // Set Mode
		var direction = o.options.direction || 'vertical'; // Default direction

		$.effects.save(el, props); el.show(); // Save & Show
		var wrapper = $.effects.createWrapper(el).css({overflow:'hidden'}); // Create Wrapper
		var ref = (direction == 'vertical') ? 'height' : 'width';
		var distance = (direction == 'vertical') ? wrapper.height() : wrapper.width();
		if(mode == 'show') wrapper.css(ref, 0); // Shift

		var animation = {};
		animation[ref] = mode == 'show' ? distance : 0;

		wrapper.animate(animation, o.duration, o.options.easing, function() {
			if(mode == 'hide') el.hide(); // Hide
			$.effects.restore(el, props); $.effects.removeWrapper(el); // Restore
			if(o.callback) o.callback.apply(el[0], arguments); // Callback
			el.dequeue();
		});

	});

};

})(jQuery);
/*
 * jQuery UI Effects Bounce 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Bounce
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.bounce = function(o) {

	return this.queue(function() {

		var el = $(this), props = ['position','top','left'];

		var mode = $.effects.setMode(el, o.options.mode || 'effect'); // Set Mode
		var direction = o.options.direction || 'up'; // Default direction
		var distance = o.options.distance || 20; // Default distance
		var times = o.options.times || 5; // Default # of times
		var speed = o.duration || 250; // Default speed per bounce
		if (/show|hide/.test(mode)) props.push('opacity'); // Avoid touching opacity to prevent clearType and PNG issues in IE

		$.effects.save(el, props); el.show(); // Save & Show
		$.effects.createWrapper(el); // Create Wrapper
		var ref = (direction == 'up' || direction == 'down') ? 'top' : 'left';
		var motion = (direction == 'up' || direction == 'left') ? 'pos' : 'neg';
		var distance = o.options.distance || (ref == 'top' ? el.outerHeight({margin:true}) / 3 : el.outerWidth({margin:true}) / 3);
		if (mode == 'show') el.css('opacity', 0).css(ref, motion == 'pos' ? -distance : distance); // Shift
		if (mode == 'hide') distance = distance / (times * 2);
		if (mode != 'hide') times--;

		if (mode == 'show') { // Show Bounce
			var animation = {opacity: 1};
			animation[ref] = (motion == 'pos' ? '+=' : '-=') + distance;
			el.animate(animation, speed / 2, o.options.easing);
			distance = distance / 2;
			times--;
		};
		for (var i = 0; i < times; i++) { // Bounces
			var animation1 = {}, animation2 = {};
			animation1[ref] = (motion == 'pos' ? '-=' : '+=') + distance;
			animation2[ref] = (motion == 'pos' ? '+=' : '-=') + distance;
			el.animate(animation1, speed / 2, o.options.easing).animate(animation2, speed / 2, o.options.easing);
			distance = (mode == 'hide') ? distance * 2 : distance / 2;
		};
		if (mode == 'hide') { // Last Bounce
			var animation = {opacity: 0};
			animation[ref] = (motion == 'pos' ? '-=' : '+=')  + distance;
			el.animate(animation, speed / 2, o.options.easing, function(){
				el.hide(); // Hide
				$.effects.restore(el, props); $.effects.removeWrapper(el); // Restore
				if(o.callback) o.callback.apply(this, arguments); // Callback
			});
		} else {
			var animation1 = {}, animation2 = {};
			animation1[ref] = (motion == 'pos' ? '-=' : '+=') + distance;
			animation2[ref] = (motion == 'pos' ? '+=' : '-=') + distance;
			el.animate(animation1, speed / 2, o.options.easing).animate(animation2, speed / 2, o.options.easing, function(){
				$.effects.restore(el, props); $.effects.removeWrapper(el); // Restore
				if(o.callback) o.callback.apply(this, arguments); // Callback
			});
		};
		el.queue('fx', function() { el.dequeue(); });
		el.dequeue();
	});

};

})(jQuery);
/*
 * jQuery UI Effects Clip 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Clip
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.clip = function(o) {

	return this.queue(function() {

		var el = $(this), props = ['position','top','left','height','width'];

		var mode = $.effects.setMode(el, o.options.mode || 'hide'); // Set Mode
		var direction = o.options.direction || 'vertical'; // Default direction

		$.effects.save(el, props); el.show(); // Save & Show
		var wrapper = $.effects.createWrapper(el).css({overflow:'hidden'}); // Create Wrapper
		var animate = el[0].tagName == 'IMG' ? wrapper : el;
		var ref = {
			size: (direction == 'vertical') ? 'height' : 'width',
			position: (direction == 'vertical') ? 'top' : 'left'
		};
		var distance = (direction == 'vertical') ? animate.height() : animate.width();
		if(mode == 'show') { animate.css(ref.size, 0); animate.css(ref.position, distance / 2); } // Shift

		var animation = {};
		animation[ref.size] = mode == 'show' ? distance : 0;
		animation[ref.position] = mode == 'show' ? 0 : distance / 2;

		animate.animate(animation, { queue: false, duration: o.duration, easing: o.options.easing, complete: function() {
			if(mode == 'hide') el.hide(); // Hide
			$.effects.restore(el, props); $.effects.removeWrapper(el); // Restore
			if(o.callback) o.callback.apply(el[0], arguments); // Callback
			el.dequeue();
		}});

	});

};

})(jQuery);
/*
 * jQuery UI Effects Drop 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Drop
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.drop = function(o) {

	return this.queue(function() {

		var el = $(this), props = ['position','top','left','opacity'];

		var mode = $.effects.setMode(el, o.options.mode || 'hide'); // Set Mode
		var direction = o.options.direction || 'left'; // Default Direction

		$.effects.save(el, props); el.show(); // Save & Show
		$.effects.createWrapper(el); // Create Wrapper
		var ref = (direction == 'up' || direction == 'down') ? 'top' : 'left';
		var motion = (direction == 'up' || direction == 'left') ? 'pos' : 'neg';
		var distance = o.options.distance || (ref == 'top' ? el.outerHeight({margin:true}) / 2 : el.outerWidth({margin:true}) / 2);
		if (mode == 'show') el.css('opacity', 0).css(ref, motion == 'pos' ? -distance : distance); // Shift

		var animation = {opacity: mode == 'show' ? 1 : 0};
		animation[ref] = (mode == 'show' ? (motion == 'pos' ? '+=' : '-=') : (motion == 'pos' ? '-=' : '+=')) + distance;

		el.animate(animation, { queue: false, duration: o.duration, easing: o.options.easing, complete: function() {
			if(mode == 'hide') el.hide(); // Hide
			$.effects.restore(el, props); $.effects.removeWrapper(el); // Restore
			if(o.callback) o.callback.apply(this, arguments); // Callback
			el.dequeue();
		}});

	});

};

})(jQuery);
/*
 * jQuery UI Effects Explode 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Explode
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.explode = function(o) {

	return this.queue(function() {

	var rows = o.options.pieces ? Math.round(Math.sqrt(o.options.pieces)) : 3;
	var cells = o.options.pieces ? Math.round(Math.sqrt(o.options.pieces)) : 3;

	o.options.mode = o.options.mode == 'toggle' ? ($(this).is(':visible') ? 'hide' : 'show') : o.options.mode;
	var el = $(this).show().css('visibility', 'hidden');
	var offset = el.offset();

	offset.top -= parseInt(el.css("marginTop"),10) || 0;
	offset.left -= parseInt(el.css("marginLeft"),10) || 0;

	var width = el.outerWidth(true);
	var height = el.outerHeight(true);

	for(var i=0;i<rows;i++) { // =
		for(var j=0;j<cells;j++) { // ||
			el
				.clone()
				.appendTo('body')
				.wrap('<div></div>')
				.css({
					position: 'absolute',
					visibility: 'visible',
					left: -j*(width/cells),
					top: -i*(height/rows)
				})
				.parent()
				.addClass('ui-effects-explode')
				.css({
					position: 'absolute',
					overflow: 'hidden',
					width: width/cells,
					height: height/rows,
					left: offset.left + j*(width/cells) + (o.options.mode == 'show' ? (j-Math.floor(cells/2))*(width/cells) : 0),
					top: offset.top + i*(height/rows) + (o.options.mode == 'show' ? (i-Math.floor(rows/2))*(height/rows) : 0),
					opacity: o.options.mode == 'show' ? 0 : 1
				}).animate({
					left: offset.left + j*(width/cells) + (o.options.mode == 'show' ? 0 : (j-Math.floor(cells/2))*(width/cells)),
					top: offset.top + i*(height/rows) + (o.options.mode == 'show' ? 0 : (i-Math.floor(rows/2))*(height/rows)),
					opacity: o.options.mode == 'show' ? 1 : 0
				}, o.duration || 500);
		}
	}

	setTimeout(function() {

		o.options.mode == 'show' ? el.css({ visibility: 'visible' }) : el.css({ visibility: 'visible' }).hide();
				if(o.callback) o.callback.apply(el[0]); // Callback
				el.dequeue();

				$('div.ui-effects-explode').remove();

	}, o.duration || 500);


	});

};

})(jQuery);
/*
 * jQuery UI Effects Fold 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Fold
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.fold = function(o) {

	return this.queue(function() {

		var el = $(this), props = ['position','top','left'];

		var mode = $.effects.setMode(el, o.options.mode || 'hide'); // Set Mode
		var size = o.options.size || 15; // Default fold size
		var horizFirst = !(!o.options.horizFirst); // Ensure a boolean value
		var duration = o.duration ? o.duration / 2 : $.fx.speeds._default / 2;

		$.effects.save(el, props); el.show(); // Save & Show
		var wrapper = $.effects.createWrapper(el).css({overflow:'hidden'}); // Create Wrapper
		var widthFirst = ((mode == 'show') != horizFirst);
		var ref = widthFirst ? ['width', 'height'] : ['height', 'width'];
		var distance = widthFirst ? [wrapper.width(), wrapper.height()] : [wrapper.height(), wrapper.width()];
		var percent = /([0-9]+)%/.exec(size);
		if(percent) size = parseInt(percent[1],10) / 100 * distance[mode == 'hide' ? 0 : 1];
		if(mode == 'show') wrapper.css(horizFirst ? {height: 0, width: size} : {height: size, width: 0}); // Shift

		var animation1 = {}, animation2 = {};
		animation1[ref[0]] = mode == 'show' ? distance[0] : size;
		animation2[ref[1]] = mode == 'show' ? distance[1] : 0;

		wrapper.animate(animation1, duration, o.options.easing)
		.animate(animation2, duration, o.options.easing, function() {
			if(mode == 'hide') el.hide(); // Hide
			$.effects.restore(el, props); $.effects.removeWrapper(el); // Restore
			if(o.callback) o.callback.apply(el[0], arguments); // Callback
			el.dequeue();
		});

	});

};

})(jQuery);
/*
 * jQuery UI Effects Highlight 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Highlight
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.highlight = function(o) {

	return this.queue(function() {

		var el = $(this), props = ['backgroundImage','backgroundColor','opacity'];

		var mode = $.effects.setMode(el, o.options.mode || 'show'); // Set Mode
		var color = o.options.color || "#ffff99"; // Default highlight color
		var oldColor = el.css("backgroundColor");

		$.effects.save(el, props); el.show(); // Save & Show
		el.css({backgroundImage: 'none', backgroundColor: color}); // Shift

		var animation = {backgroundColor: oldColor };
		if (mode == "hide") animation['opacity'] = 0;

		el.animate(animation, { queue: false, duration: o.duration, easing: o.options.easing, complete: function() {
			if(mode == "hide") el.hide();
			$.effects.restore(el, props);
		if (mode == "show" && $.browser.msie) this.style.removeAttribute('filter');
			if(o.callback) o.callback.apply(this, arguments);
			el.dequeue();
		}});

	});

};

})(jQuery);
/*
 * jQuery UI Effects Pulsate 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Pulsate
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.pulsate = function(o) {

	return this.queue(function() {

		var el = $(this);

		var mode = $.effects.setMode(el, o.options.mode || 'show'); // Set Mode
		var times = o.options.times || 5; // Default # of times
		var duration = o.duration ? o.duration / 2 : $.fx.speeds._default / 2;

		if (mode == 'hide') times--;
		if (el.is(':hidden')) { // Show fadeIn
			el.css('opacity', 0);
			el.show(); // Show
			el.animate({opacity: 1}, duration, o.options.easing);
			times = times-2;
		}

		for (var i = 0; i < times; i++) { // Pulsate
			el.animate({opacity: 0}, duration, o.options.easing).animate({opacity: 1}, duration, o.options.easing);
		};
		if (mode == 'hide') { // Last Pulse
			el.animate({opacity: 0}, duration, o.options.easing, function(){
				el.hide(); // Hide
				if(o.callback) o.callback.apply(this, arguments); // Callback
			});
		} else {
			el.animate({opacity: 0}, duration, o.options.easing).animate({opacity: 1}, duration, o.options.easing, function(){
				if(o.callback) o.callback.apply(this, arguments); // Callback
			});
		};
		el.queue('fx', function() { el.dequeue(); });
		el.dequeue();
	});

};

})(jQuery);
/*
 * jQuery UI Effects Scale 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Scale
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.puff = function(o) {

	return this.queue(function() {

		var el = $(this);

		var options = $.extend(true, {}, o.options);
		var mode = $.effects.setMode(el, o.options.mode || 'hide'); // Set Mode
		var percent = parseInt(o.options.percent,10) || 150; // Set default puff percent
		options.fade = true; // It's not a puff if it doesn't fade! :)
		var original = {height: el.height(), width: el.width()}; // Save original

		var factor = percent / 100;
		el.from = (mode == 'hide') ? original : {height: original.height * factor, width: original.width * factor};

		options.from = el.from;
		options.percent = (mode == 'hide') ? percent : 100;
		options.mode = mode;

		el.effect('scale', options, o.duration, o.callback);
		el.dequeue();
	});

};

$.effects.scale = function(o) {

	return this.queue(function() {

		var el = $(this);

		var options = $.extend(true, {}, o.options);
		var mode = $.effects.setMode(el, o.options.mode || 'effect'); // Set Mode
		var percent = parseInt(o.options.percent,10) || (parseInt(o.options.percent,10) == 0 ? 0 : (mode == 'hide' ? 0 : 100)); // Set default scaling percent
		var direction = o.options.direction || 'both'; // Set default axis
		var origin = o.options.origin; // The origin of the scaling
		if (mode != 'effect') { // Set default origin and restore for show/hide
			options.origin = origin || ['middle','center'];
			options.restore = true;
		}
		var original = {height: el.height(), width: el.width()}; // Save original
		el.from = o.options.from || (mode == 'show' ? {height: 0, width: 0} : original); // Default from state

		var factor = { // Set scaling factor
			y: direction != 'horizontal' ? (percent / 100) : 1,
			x: direction != 'vertical' ? (percent / 100) : 1
		};
		el.to = {height: original.height * factor.y, width: original.width * factor.x}; // Set to state

		if (o.options.fade) { // Fade option to support puff
			if (mode == 'show') {el.from.opacity = 0; el.to.opacity = 1;};
			if (mode == 'hide') {el.from.opacity = 1; el.to.opacity = 0;};
		};

		options.from = el.from; options.to = el.to; options.mode = mode;

		el.effect('size', options, o.duration, o.callback);
		el.dequeue();
	});

};

$.effects.size = function(o) {

	return this.queue(function() {

		var el = $(this), props = ['position','top','left','width','height','overflow','opacity'];
		var props1 = ['position','top','left','overflow','opacity']; // Always restore
		var props2 = ['width','height','overflow']; // Copy for children
		var cProps = ['fontSize'];
		var vProps = ['borderTopWidth', 'borderBottomWidth', 'paddingTop', 'paddingBottom'];
		var hProps = ['borderLeftWidth', 'borderRightWidth', 'paddingLeft', 'paddingRight'];

		var mode = $.effects.setMode(el, o.options.mode || 'effect'); // Set Mode
		var restore = o.options.restore || false; // Default restore
		var scale = o.options.scale || 'both'; // Default scale mode
		var origin = o.options.origin; // The origin of the sizing
		var original = {height: el.height(), width: el.width()}; // Save original
		el.from = o.options.from || original; // Default from state
		el.to = o.options.to || original; // Default to state
		if (origin) { // Calculate baseline shifts
			var baseline = $.effects.getBaseline(origin, original);
			el.from.top = (original.height - el.from.height) * baseline.y;
			el.from.left = (original.width - el.from.width) * baseline.x;
			el.to.top = (original.height - el.to.height) * baseline.y;
			el.to.left = (original.width - el.to.width) * baseline.x;
		};
		var factor = { // Set scaling factor
			from: {y: el.from.height / original.height, x: el.from.width / original.width},
			to: {y: el.to.height / original.height, x: el.to.width / original.width}
		};
		if (scale == 'box' || scale == 'both') { // Scale the css box
			if (factor.from.y != factor.to.y) { // Vertical props scaling
				props = props.concat(vProps);
				el.from = $.effects.setTransition(el, vProps, factor.from.y, el.from);
				el.to = $.effects.setTransition(el, vProps, factor.to.y, el.to);
			};
			if (factor.from.x != factor.to.x) { // Horizontal props scaling
				props = props.concat(hProps);
				el.from = $.effects.setTransition(el, hProps, factor.from.x, el.from);
				el.to = $.effects.setTransition(el, hProps, factor.to.x, el.to);
			};
		};
		if (scale == 'content' || scale == 'both') { // Scale the content
			if (factor.from.y != factor.to.y) { // Vertical props scaling
				props = props.concat(cProps);
				el.from = $.effects.setTransition(el, cProps, factor.from.y, el.from);
				el.to = $.effects.setTransition(el, cProps, factor.to.y, el.to);
			};
		};
		$.effects.save(el, restore ? props : props1); el.show(); // Save & Show
		$.effects.createWrapper(el); // Create Wrapper
		el.css('overflow','hidden').css(el.from); // Shift

		if (scale == 'content' || scale == 'both') { // Scale the children
			vProps = vProps.concat(['marginTop','marginBottom']).concat(cProps); // Add margins/font-size
			hProps = hProps.concat(['marginLeft','marginRight']); // Add margins
			props2 = props.concat(vProps).concat(hProps); // Concat
			el.find("*[width]").each(function(){
				child = $(this);
				if (restore) $.effects.save(child, props2);
				var c_original = {height: child.height(), width: child.width()}; // Save original
				child.from = {height: c_original.height * factor.from.y, width: c_original.width * factor.from.x};
				child.to = {height: c_original.height * factor.to.y, width: c_original.width * factor.to.x};
				if (factor.from.y != factor.to.y) { // Vertical props scaling
					child.from = $.effects.setTransition(child, vProps, factor.from.y, child.from);
					child.to = $.effects.setTransition(child, vProps, factor.to.y, child.to);
				};
				if (factor.from.x != factor.to.x) { // Horizontal props scaling
					child.from = $.effects.setTransition(child, hProps, factor.from.x, child.from);
					child.to = $.effects.setTransition(child, hProps, factor.to.x, child.to);
				};
				child.css(child.from); // Shift children
				child.animate(child.to, o.duration, o.options.easing, function(){
					if (restore) $.effects.restore(child, props2); // Restore children
				}); // Animate children
			});
		};

		el.animate(el.to, { queue: false, duration: o.duration, easing: o.options.easing, complete: function() {
			if(mode == 'hide') el.hide(); // Hide
			$.effects.restore(el, restore ? props : props1); $.effects.removeWrapper(el); // Restore
			if(o.callback) o.callback.apply(this, arguments); // Callback
			el.dequeue();
		}});

	});

};

})(jQuery);
/*
 * jQuery UI Effects Shake 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Shake
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.shake = function(o) {

	return this.queue(function() {

		var el = $(this), props = ['position','top','left'];

		var mode = $.effects.setMode(el, o.options.mode || 'effect'); // Set Mode
		var direction = o.options.direction || 'left'; // Default direction
		var distance = o.options.distance || 20; // Default distance
		var times = o.options.times || 3; // Default # of times
		var speed = o.duration || o.options.duration || 140; // Default speed per shake

		$.effects.save(el, props); el.show(); // Save & Show
		$.effects.createWrapper(el); // Create Wrapper
		var ref = (direction == 'up' || direction == 'down') ? 'top' : 'left';
		var motion = (direction == 'up' || direction == 'left') ? 'pos' : 'neg';

		var animation = {}, animation1 = {}, animation2 = {};
		animation[ref] = (motion == 'pos' ? '-=' : '+=')  + distance;
		animation1[ref] = (motion == 'pos' ? '+=' : '-=')  + distance * 2;
		animation2[ref] = (motion == 'pos' ? '-=' : '+=')  + distance * 2;

		el.animate(animation, speed, o.options.easing);
		for (var i = 1; i < times; i++) { // Shakes
			el.animate(animation1, speed, o.options.easing).animate(animation2, speed, o.options.easing);
		};
		el.animate(animation1, speed, o.options.easing).
		animate(animation, speed / 2, o.options.easing, function(){ // Last shake
			$.effects.restore(el, props); $.effects.removeWrapper(el); // Restore
			if(o.callback) o.callback.apply(this, arguments); // Callback
		});
		el.queue('fx', function() { el.dequeue(); });
		el.dequeue();
	});

};

})(jQuery);
/*
 * jQuery UI Effects Slide 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Slide
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.slide = function(o) {

	return this.queue(function() {

		var el = $(this), props = ['position','top','left'];

		var mode = $.effects.setMode(el, o.options.mode || 'show'); // Set Mode
		var direction = o.options.direction || 'left'; // Default Direction

		$.effects.save(el, props); el.show(); // Save & Show
		$.effects.createWrapper(el).css({overflow:'hidden'}); // Create Wrapper
		var ref = (direction == 'up' || direction == 'down') ? 'top' : 'left';
		var motion = (direction == 'up' || direction == 'left') ? 'pos' : 'neg';
		var distance = o.options.distance || (ref == 'top' ? el.outerHeight({margin:true}) : el.outerWidth({margin:true}));
		if (mode == 'show') el.css(ref, motion == 'pos' ? -distance : distance); // Shift

		var animation = {};
		animation[ref] = (mode == 'show' ? (motion == 'pos' ? '+=' : '-=') : (motion == 'pos' ? '-=' : '+=')) + distance;

		el.animate(animation, { queue: false, duration: o.duration, easing: o.options.easing, complete: function() {
			if(mode == 'hide') el.hide(); // Hide
			$.effects.restore(el, props); $.effects.removeWrapper(el); // Restore
			if(o.callback) o.callback.apply(this, arguments); // Callback
			el.dequeue();
		}});

	});

};

})(jQuery);
/*
 * jQuery UI Effects Transfer 1.7.2
 *
 * Copyright (c) 2009 AUTHORS.txt (http://jqueryui.com/about)
 * Dual licensed under the MIT (MIT-LICENSE.txt)
 * and GPL (GPL-LICENSE.txt) licenses.
 *
 * http://docs.jquery.com/UI/Effects/Transfer
 *
 * Depends:
 *	effects.core.js
 */
(function($) {

$.effects.transfer = function(o) {
	return this.queue(function() {
		var elem = $(this),
			target = $(o.options.to),
			endPosition = target.offset(),
			animation = {
				top: endPosition.top,
				left: endPosition.left,
				height: target.innerHeight(),
				width: target.innerWidth()
			},
			startPosition = elem.offset(),
			transfer = $('<div class="ui-effects-transfer"></div>')
				.appendTo(document.body)
				.addClass(o.options.className)
				.css({
					top: startPosition.top,
					left: startPosition.left,
					height: elem.innerHeight(),
					width: elem.innerWidth(),
					position: 'absolute'
				})
				.animate(animation, o.duration, o.options.easing, function() {
					transfer.remove();
					(o.callback && o.callback.apply(elem[0], arguments));
					elem.dequeue();
				});
	});
};

})(jQuery);
/*
 * jQuery Form Plugin
 * version: 2.18 (06-JAN-2009)
 * @requires jQuery v1.2.2 or later
 *
 * Examples and documentation at: http://malsup.com/jquery/form/
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Revision: $Id$
 */
;(function($) {

/*
    Usage Note:
    -----------
    Do not use both ajaxSubmit and ajaxForm on the same form.  These
    functions are intended to be exclusive.  Use ajaxSubmit if you want
    to bind your own submit handler to the form.  For example,

    $(document).ready(function() {
        $('#myForm').bind('submit', function() {
            $(this).ajaxSubmit({
                target: '#output'
            });
            return false; // <-- important!
        });
    });

    Use ajaxForm when you want the plugin to manage all the event binding
    for you.  For example,

    $(document).ready(function() {
        $('#myForm').ajaxForm({
            target: '#output'
        });
    });

    When using ajaxForm, the ajaxSubmit function will be invoked for you
    at the appropriate time.
*/

/**
 * ajaxSubmit() provides a mechanism for immediately submitting
 * an HTML form using AJAX.
 */
$.fn.ajaxSubmit = function(options) {
    if (!this.length) {
        log('ajaxSubmit: skipping submit process - no element selected');
        return this;
    }

    if (typeof options == 'function')
        options = { success: options };

    options = $.extend({
        url:  this.attr('action') || window.location.toString(),
        type: this.attr('method') || 'GET'
    }, options || {});

    var veto = {};
    this.trigger('form-pre-serialize', [this, options, veto]);
    if (veto.veto) {
        log('ajaxSubmit: submit vetoed via form-pre-serialize trigger');
        return this;
    }

    if (options.beforeSerialize && options.beforeSerialize(this, options) === false) {
        log('ajaxSubmit: submit aborted via beforeSerialize callback');
        return this;
    }

    var a = this.formToArray(options.semantic);
    if (options.data) {
        options.extraData = options.data;
        for (var n in options.data) {
          if(options.data[n] instanceof Array) {
            for (var k in options.data[n])
              a.push( { name: n, value: options.data[n][k] } )
          }
          else
             a.push( { name: n, value: options.data[n] } );
        }
    }

    if (options.beforeSubmit && options.beforeSubmit(a, this, options) === false) {
        log('ajaxSubmit: submit aborted via beforeSubmit callback');
        return this;
    }

    this.trigger('form-submit-validate', [a, this, options, veto]);
    if (veto.veto) {
        log('ajaxSubmit: submit vetoed via form-submit-validate trigger');
        return this;
    }

    var q = $.param(a);

    if (options.type.toUpperCase() == 'GET') {
        options.url += (options.url.indexOf('?') >= 0 ? '&' : '?') + q;
        options.data = null;  // data is null for 'get'
    }
    else
        options.data = q; // data is the query string for 'post'

    var $form = this, callbacks = [];
    if (options.resetForm) callbacks.push(function() { $form.resetForm(); });
    if (options.clearForm) callbacks.push(function() { $form.clearForm(); });

    if (!options.dataType && options.target) {
        var oldSuccess = options.success || function(){};
        callbacks.push(function(data) {
            $(options.target).html(data).each(oldSuccess, arguments);
        });
    }
    else if (options.success)
        callbacks.push(options.success);

    options.success = function(data, status) {
        for (var i=0, max=callbacks.length; i < max; i++)
            callbacks[i].apply(options, [data, status, $form]);
    };

    var files = $('input:file', this).fieldValue();
    var found = false;
    for (var j=0; j < files.length; j++)
        if (files[j])
            found = true;

   if (options.iframe || found) {
       if ($.browser.safari && options.closeKeepAlive)
           $.get(options.closeKeepAlive, fileUpload);
       else
           fileUpload();
       }
   else
       $.ajax(options);

    this.trigger('form-submit-notify', [this, options]);
    return this;


    function fileUpload() {
        var form = $form[0];

        if ($(':input[name=submit]', form).length) {
            alert('Error: Form elements must not be named "submit".');
            return;
        }

        var opts = $.extend({}, $.ajaxSettings, options);
		var s = jQuery.extend(true, {}, $.extend(true, {}, $.ajaxSettings), opts);

        var id = 'jqFormIO' + (new Date().getTime());
        var $io = $('<iframe id="' + id + '" name="' + id + '" />');
        var io = $io[0];

        if ($.browser.msie || $.browser.opera)
            io.src = 'javascript:false;document.write("");';
        $io.css({ position: 'absolute', top: '-1000px', left: '-1000px' });

        var xhr = { // mock object
            aborted: 0,
            responseText: null,
            responseXML: null,
            status: 0,
            statusText: 'n/a',
            getAllResponseHeaders: function() {},
            getResponseHeader: function() {},
            setRequestHeader: function() {},
            abort: function() {
                this.aborted = 1;
                $io.attr('src','about:blank'); // abort op in progress
            }
        };

        var g = opts.global;
        if (g && ! $.active++) $.event.trigger("ajaxStart");
        if (g) $.event.trigger("ajaxSend", [xhr, opts]);

		if (s.beforeSend && s.beforeSend(xhr, s) === false) {
			s.global && jQuery.active--;
			return;
        }
        if (xhr.aborted)
            return;

        var cbInvoked = 0;
        var timedOut = 0;

        var sub = form.clk;
        if (sub) {
            var n = sub.name;
            if (n && !sub.disabled) {
                options.extraData = options.extraData || {};
                options.extraData[n] = sub.value;
                if (sub.type == "image") {
                    options.extraData[name+'.x'] = form.clk_x;
                    options.extraData[name+'.y'] = form.clk_y;
                }
            }
        }

        setTimeout(function() {
            var t = $form.attr('target'), a = $form.attr('action');
            $form.attr({
                target:   id,
                method:   'POST',
                action:   opts.url
            });

            if (! options.skipEncodingOverride) {
                $form.attr({
                    encoding: 'multipart/form-data',
                    enctype:  'multipart/form-data'
                });
            }

            if (opts.timeout)
                setTimeout(function() { timedOut = true; cb(); }, opts.timeout);

            var extraInputs = [];
            try {
                if (options.extraData)
                    for (var n in options.extraData)
                        extraInputs.push(
                            $('<input type="hidden" name="'+n+'" value="'+options.extraData[n]+'" />')
                                .appendTo(form)[0]);

                $io.appendTo('body');
                io.attachEvent ? io.attachEvent('onload', cb) : io.addEventListener('load', cb, false);
                form.submit();
            }
            finally {
                $form.attr('action', a);
                t ? $form.attr('target', t) : $form.removeAttr('target');
                $(extraInputs).remove();
            }
        }, 10);

        function cb() {
            if (cbInvoked++) return;

            io.detachEvent ? io.detachEvent('onload', cb) : io.removeEventListener('load', cb, false);

            var operaHack = 0;
            var ok = true;
            try {
                if (timedOut) throw 'timeout';
                var data, doc;

                doc = io.contentWindow ? io.contentWindow.document : io.contentDocument ? io.contentDocument : io.document;

                if (doc.body == null && !operaHack && $.browser.opera) {
                    operaHack = 1;
                    cbInvoked--;
                    setTimeout(cb, 100);
                    return;
                }

                xhr.responseText = doc.body ? doc.body.innerHTML : null;
                xhr.responseXML = doc.XMLDocument ? doc.XMLDocument : doc;
                xhr.getResponseHeader = function(header){
                    var headers = {'content-type': opts.dataType};
                    return headers[header];
                };

                if (opts.dataType == 'json' || opts.dataType == 'script') {
                    var ta = doc.getElementsByTagName('textarea')[0];
                    xhr.responseText = ta ? ta.value : xhr.responseText;
                }
                else if (opts.dataType == 'xml' && !xhr.responseXML && xhr.responseText != null) {
                    xhr.responseXML = toXml(xhr.responseText);
                }
                data = $.httpData(xhr, opts.dataType);
            }
            catch(e){
                ok = false;
                $.handleError(opts, xhr, 'error', e);
            }

            if (ok) {
                opts.success(data, 'success');
                if (g) $.event.trigger("ajaxSuccess", [xhr, opts]);
            }
            if (g) $.event.trigger("ajaxComplete", [xhr, opts]);
            if (g && ! --$.active) $.event.trigger("ajaxStop");
            if (opts.complete) opts.complete(xhr, ok ? 'success' : 'error');

            setTimeout(function() {
                $io.remove();
                xhr.responseXML = null;
            }, 100);
        };

        function toXml(s, doc) {
            if (window.ActiveXObject) {
                doc = new ActiveXObject('Microsoft.XMLDOM');
                doc.async = 'false';
                doc.loadXML(s);
            }
            else
                doc = (new DOMParser()).parseFromString(s, 'text/xml');
            return (doc && doc.documentElement && doc.documentElement.tagName != 'parsererror') ? doc : null;
        };
    };
};

/**
 * ajaxForm() provides a mechanism for fully automating form submission.
 *
 * The advantages of using this method instead of ajaxSubmit() are:
 *
 * 1: This method will include coordinates for <input type="image" /> elements (if the element
 *    is used to submit the form).
 * 2. This method will include the submit element's name/value data (for the element that was
 *    used to submit the form).
 * 3. This method binds the submit() method to the form for you.
 *
 * The options argument for ajaxForm works exactly as it does for ajaxSubmit.  ajaxForm merely
 * passes the options argument along after properly binding events for submit elements and
 * the form itself.
 */
$.fn.ajaxForm = function(options) {
    return this.ajaxFormUnbind().bind('submit.form-plugin',function() {
        $(this).ajaxSubmit(options);
        return false;
    }).each(function() {
        $(":submit,input:image", this).bind('click.form-plugin',function(e) {
            var form = this.form;
            form.clk = this;
            if (this.type == 'image') {
                if (e.offsetX != undefined) {
                    form.clk_x = e.offsetX;
                    form.clk_y = e.offsetY;
                } else if (typeof $.fn.offset == 'function') { // try to use dimensions plugin
                    var offset = $(this).offset();
                    form.clk_x = e.pageX - offset.left;
                    form.clk_y = e.pageY - offset.top;
                } else {
                    form.clk_x = e.pageX - this.offsetLeft;
                    form.clk_y = e.pageY - this.offsetTop;
                }
            }
            setTimeout(function() { form.clk = form.clk_x = form.clk_y = null; }, 10);
        });
    });
};

$.fn.ajaxFormUnbind = function() {
    this.unbind('submit.form-plugin');
    return this.each(function() {
        $(":submit,input:image", this).unbind('click.form-plugin');
    });

};

/**
 * formToArray() gathers form element data into an array of objects that can
 * be passed to any of the following ajax functions: $.get, $.post, or load.
 * Each object in the array has both a 'name' and 'value' property.  An example of
 * an array for a simple login form might be:
 *
 * [ { name: 'username', value: 'jresig' }, { name: 'password', value: 'secret' } ]
 *
 * It is this array that is passed to pre-submit callback functions provided to the
 * ajaxSubmit() and ajaxForm() methods.
 */
$.fn.formToArray = function(semantic) {
    var a = [];
    if (this.length == 0) return a;

    var form = this[0];
    var els = semantic ? form.getElementsByTagName('*') : form.elements;
    if (!els) return a;
    for(var i=0, max=els.length; i < max; i++) {
        var el = els[i];
        var n = el.name;
        if (!n) continue;

        if (semantic && form.clk && el.type == "image") {
            if(!el.disabled && form.clk == el)
                a.push({name: n+'.x', value: form.clk_x}, {name: n+'.y', value: form.clk_y});
            continue;
        }

        var v = $.fieldValue(el, true);
        if (v && v.constructor == Array) {
            for(var j=0, jmax=v.length; j < jmax; j++)
                a.push({name: n, value: v[j]});
        }
        else if (v !== null && typeof v != 'undefined')
            a.push({name: n, value: v});
    }

    if (!semantic && form.clk) {
        var inputs = form.getElementsByTagName("input");
        for(var i=0, max=inputs.length; i < max; i++) {
            var input = inputs[i];
            var n = input.name;
            if(n && !input.disabled && input.type == "image" && form.clk == input)
                a.push({name: n+'.x', value: form.clk_x}, {name: n+'.y', value: form.clk_y});
        }
    }
    return a;
};

/**
 * Serializes form data into a 'submittable' string. This method will return a string
 * in the format: name1=value1&amp;name2=value2
 */
$.fn.formSerialize = function(semantic) {
    return $.param(this.formToArray(semantic));
};

/**
 * Serializes all field elements in the jQuery object into a query string.
 * This method will return a string in the format: name1=value1&amp;name2=value2
 */
$.fn.fieldSerialize = function(successful) {
    var a = [];
    this.each(function() {
        var n = this.name;
        if (!n) return;
        var v = $.fieldValue(this, successful);
        if (v && v.constructor == Array) {
            for (var i=0,max=v.length; i < max; i++)
                a.push({name: n, value: v[i]});
        }
        else if (v !== null && typeof v != 'undefined')
            a.push({name: this.name, value: v});
    });
    return $.param(a);
};

/**
 * Returns the value(s) of the element in the matched set.  For example, consider the following form:
 *
 *  <form><fieldset>
 *      <input name="A" type="text" />
 *      <input name="A" type="text" />
 *      <input name="B" type="checkbox" value="B1" />
 *      <input name="B" type="checkbox" value="B2"/>
 *      <input name="C" type="radio" value="C1" />
 *      <input name="C" type="radio" value="C2" />
 *  </fieldset></form>
 *
 *  var v = $(':text').fieldValue();
 *  // if no values are entered into the text inputs
 *  v == ['','']
 *  // if values entered into the text inputs are 'foo' and 'bar'
 *  v == ['foo','bar']
 *
 *  var v = $(':checkbox').fieldValue();
 *  // if neither checkbox is checked
 *  v === undefined
 *  // if both checkboxes are checked
 *  v == ['B1', 'B2']
 *
 *  var v = $(':radio').fieldValue();
 *  // if neither radio is checked
 *  v === undefined
 *  // if first radio is checked
 *  v == ['C1']
 *
 * The successful argument controls whether or not the field element must be 'successful'
 * (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
 * The default value of the successful argument is true.  If this value is false the value(s)
 * for each element is returned.
 *
 * Note: This method *always* returns an array.  If no valid value can be determined the
 *       array will be empty, otherwise it will contain one or more values.
 */
$.fn.fieldValue = function(successful) {
    for (var val=[], i=0, max=this.length; i < max; i++) {
        var el = this[i];
        var v = $.fieldValue(el, successful);
        if (v === null || typeof v == 'undefined' || (v.constructor == Array && !v.length))
            continue;
        v.constructor == Array ? $.merge(val, v) : val.push(v);
    }
    return val;
};

/**
 * Returns the value of the field element.
 */
$.fieldValue = function(el, successful) {
    var n = el.name, t = el.type, tag = el.tagName.toLowerCase();
    if (typeof successful == 'undefined') successful = true;

    if (successful && (!n || el.disabled || t == 'reset' || t == 'button' ||
        (t == 'checkbox' || t == 'radio') && !el.checked ||
        (t == 'submit' || t == 'image') && el.form && el.form.clk != el ||
        tag == 'select' && el.selectedIndex == -1))
            return null;

    if (tag == 'select') {
        var index = el.selectedIndex;
        if (index < 0) return null;
        var a = [], ops = el.options;
        var one = (t == 'select-one');
        var max = (one ? index+1 : ops.length);
        for(var i=(one ? index : 0); i < max; i++) {
            var op = ops[i];
            if (op.selected) {
                var v = $.browser.msie && !(op.attributes['value'].specified) ? op.text : op.value;
                if (one) return v;
                a.push(v);
            }
        }
        return a;
    }
    return el.value;
};

/**
 * Clears the form data.  Takes the following actions on the form's input fields:
 *  - input text fields will have their 'value' property set to the empty string
 *  - select elements will have their 'selectedIndex' property set to -1
 *  - checkbox and radio inputs will have their 'checked' property set to false
 *  - inputs of type submit, button, reset, and hidden will *not* be effected
 *  - button elements will *not* be effected
 */
$.fn.clearForm = function() {
    return this.each(function() {
        $('input,select,textarea', this).clearFields();
    });
};

/**
 * Clears the selected form elements.
 */
$.fn.clearFields = $.fn.clearInputs = function() {
    return this.each(function() {
        var t = this.type, tag = this.tagName.toLowerCase();
        if (t == 'text' || t == 'password' || tag == 'textarea')
            this.value = '';
        else if (t == 'checkbox' || t == 'radio')
            this.checked = false;
        else if (tag == 'select')
            this.selectedIndex = -1;
    });
};

/**
 * Resets the form data.  Causes all form elements to be reset to their original value.
 */
$.fn.resetForm = function() {
    return this.each(function() {
        if (typeof this.reset == 'function' || (typeof this.reset == 'object' && !this.reset.nodeType))
            this.reset();
    });
};

/**
 * Enables or disables any matching elements.
 */
$.fn.enable = function(b) {
    if (b == undefined) b = true;
    return this.each(function() {
        this.disabled = !b
    });
};

/**
 * Checks/unchecks any matching checkboxes or radio buttons and
 * selects/deselects and matching option elements.
 */
$.fn.selected = function(select) {
    if (select == undefined) select = true;
    return this.each(function() {
        var t = this.type;
        if (t == 'checkbox' || t == 'radio')
            this.checked = select;
        else if (this.tagName.toLowerCase() == 'option') {
            var $sel = $(this).parent('select');
            if (select && $sel[0] && $sel[0].type == 'select-one') {
                $sel.find('option').selected(false);
            }
            this.selected = select;
        }
    });
};

function log() {
    if ($.fn.ajaxSubmit.debug && window.console && window.console.log)
        window.console.log('[jquery.form] ' + Array.prototype.join.call(arguments,''));
};

})(jQuery);

jQuery(function ($) {
	$.fn.quicksearch = function (target, opt) {

		var timeout, cache, rowcache, jq_results, val = '', e = this, options = $.extend({
			delay: 100,
			selector: null,
			stripeRows: null,
			loader: null,
			noResults: '',
			bind: 'keyup',
			onBefore: function () {
				return;
			},
			onAfter: function () {
				return;
			},
			show: function () {
				this.style.display = "";
			},
			hide: function () {
				this.style.display = "none";
			}
		}, opt);

		this.go = function () {

			var i = 0, noresults = true, vals = val.split(' ');

			var rowcache_length = rowcache.length;
			for (var i = 0; i < rowcache_length; i++)
			{
				if (this.test(vals, cache[i]) || val == "") {
					options.show.apply(rowcache[i]);
					noresults = false;
				} else {
					options.hide.apply(rowcache[i]);
				}
			}

			if (noresults) {
				this.results(false);
			} else {
				this.results(true);
				this.stripe();
			}

			this.loader(false);
			options.onAfter();

			return this;
		};

		this.stripe = function () {

			if (typeof options.stripeRows === "object" && options.stripeRows !== null)
			{
				var joined = options.stripeRows.join(' ');
				var stripeRows_length = options.stripeRows.length;

				jq_results.not(':hidden').each(function (i) {
					$(this).removeClass(joined).addClass(options.stripeRows[i % stripeRows_length]);
				});
			}

			return this;
		};

		this.strip_html = function (input) {
			var output = input.replace(new RegExp('/<[^<]+\>/g'), "");
			output = $.trim(output.toLowerCase());
			return output;
		};

		this.results = function (bool) {
			if (typeof options.noResults === "string" && options.noResults !== "") {
				if (bool) {
					$(options.noResults).hide();
				} else {
					$(options.noResults).show();
				}
			}
			return this;
		};

		this.loader = function (bool) {
			if (typeof options.loader === "string" && options.loader !== "") {
				 (bool) ? $(options.loader).show() : $(options.loader).hide();
			}
			return this;
		};

		this.test = function (vals, t) {
			for (var i = 0; i < vals.length; i += 1) {
				if (t.indexOf(vals[i]) === -1) {
					return false;
				}
			}
			return true;
		};

		this.cache = function () {

			jq_results = $(target);

			if (typeof options.noResults === "string" && options.noResults !== "") {
				jq_results = jq_results.not(options.noResults);
			}

			var t = (typeof options.selector === "string") ? jq_results.find(options.selector) : $(target).not(options.noResults);
			cache = t.map(function () {
				return e.strip_html(this.innerHTML);
			});

			rowcache = jq_results.map(function () {
				return this;
			});

			return this.go();
		};

		this.trigger = function () {
			this.loader(true);
			options.onBefore();

			window.clearTimeout(timeout);
			timeout = window.setTimeout(function () {
				e.go();
			}, options.delay);

			return this;
		};

		this.cache();
		this.results(true);
		this.stripe();
		this.loader(false);

		return this.each(function () {
			$(this).bind(options.bind, function () {
				val = $(this).val();
				e.trigger();
			});
		});

	};
});
/*--------------------------------------------------------------------------
 *  EJS - Embedded JavaScript, version 0.1.0
 *  Copyright (c) 2007 Edward Benson
 *  http://www.edwardbenson.com/projects/ejs
 *  ------------------------------------------------------------------------

/* Make a split function like Ruby's: "abc".split(/b/) -> ['a', 'b', 'c'] */
String.prototype.rsplit = function(regex) {
	var item = this;
	var result = regex.exec(item);
	var retArr = new Array();
	while (result != null)
	{
		var first_idx = result.index;
		var last_idx = regex.lastIndex;
		if ((first_idx) != 0)
		{
			var first_bit = item.substring(0,first_idx);
			retArr.push(item.substring(0,first_idx));
			item = item.slice(first_idx);
		}
		retArr.push(result[0]);
		item = item.slice(result[0].length);
		result = regex.exec(item);
	}
	if (! item == '')
	{
		retArr.push(item);
	}
	return retArr;
};

/* Chop is nice to have too */
String.prototype.chop = function() {
	return this.substr(0, this.length - 1);
}

/* Adaptation from the Scanner of erb.rb  */
var EjsScanner = function(source, left, right) {
	this.left_delimiter = 	left +'%'	//<%
	this.right_delimiter = 	'%'+right	//>
	this.double_left = 		left+'%%'
	this.double_right = 	'%%'+right
	this.left_equal = 		left+'%='
	this.left_comment = 	left+'%#'
	if(left=='[')
		this.SplitRegexp = /(\[%%)|(%%\])|(\[%=)|(\[%#)|(\[%)|(%\]\n)|(%\])|(\n)/;
	else
		this.SplitRegexp = new RegExp('('+this.double_left+')|(%%'+this.double_right+')|('+this.left_equal+')|('+this.left_comment+')|('+this.left_delimiter+')|('+this.right_delimiter+'\n)|('+this.right_delimiter+')|(\n)')

	this.source = source;
	this.stag = null;
	this.lines = 0;
};
EjsView = function(data){
	this.data = data
}
EjsView.prototype.partial = function(options, data){
	if(!data) data = this.data;
	return new EJS(options).render(data);
}

EjsScanner.to_text = function(input){
	if(input == null || input === undefined)
        return '';
    if(input instanceof Date)
		return input.toDateString();
	if(input.toString)
        return input.toString()
	return '';
}

EjsScanner.prototype = {

  /* For each line, scan! */
  scan: function(block) {
     scanline = this.scanline;
	 regex = this.SplitRegexp;
	 if (! this.source == '')
	 {
	 	 var source_split = this.source.rsplit(/\n/);
	 	 for(var i=0; i<source_split.length; i++) {
		 	 var item = source_split[i];
			 this.scanline(item, regex, block);
		 }
	 }
  },

  /* For each token, block! */
  scanline: function(line, regex, block) {
	 this.lines++
	 var line_split = line.rsplit(regex);
 	 for(var i=0; i<line_split.length; i++) {
	   var token = line_split[i];
       if (token != null) {
		   	try{
	         	block(token, this);
		 	}catch(e){
				throw {type: 'EjsScanner', line: this.lines}
			}
       }
	 }
  }
};

/* Adaptation from the Buffer of erb.rb  */
var EjsBuffer = function(pre_cmd, post_cmd) {
	this.line = new Array();
	this.script = "";
	this.pre_cmd = pre_cmd;
	this.post_cmd = post_cmd;

	for (var i=0; i<this.pre_cmd.length; i++)
	{
		this.push(pre_cmd[i]);
	}
}
EjsBuffer.prototype = {

  push: function(cmd) {
	this.line.push(cmd);
  },

  cr: function() {
	this.script = this.script + this.line.join('; ');
	this.line = new Array();
	this.script = this.script + "\n";
  },

  close: function() {
	if (this.line.length > 0)
	{
		for (var i=0; i<this.post_cmd.length; i++)
		{
			this.push(pre_cmd[i]);
		}
		this.script = this.script + this.line.join('; ');
		line = null;
	}
  }

};

/* Adaptation from the Compiler of erb.rb  */
EjsCompiler = function(source, left) {
	this.pre_cmd = ['___ejsO = "";'];
	this.post_cmd = new Array();
	this.source = ' ';
	if (source != null)
	{
		if (typeof source == 'string')
		{
		    source = source.replace(/\r\n/g, "\n");
            source = source.replace(/\r/g,   "\n");
			this.source = source;
		}
		else if (source.innerHTML)
		{
			this.source = source.innerHTML;
		}
		if (typeof this.source != 'string')
		{
			this.source = "";
		}
	}
	left = left || '<'
	var right = '>'
	switch(left) {
		case '[':
			right = ']'
			break;
		case '<':
			break;
		default:
			throw left+' is not a supported deliminator'
			break;
	}
	this.scanner = new EjsScanner(this.source, left, right);
	this.out = '';
}
EjsCompiler.prototype = {
  compile: function(options) {
  	options = options || {};
	this.out = '';
	var put_cmd = "___ejsO += ";
	var insert_cmd = put_cmd;
	var buff = new EjsBuffer(this.pre_cmd, this.post_cmd);
	var content = '';
	var clean = function(content)
	{
	    content = content.replace(/\\/g, '\\\\');
        content = content.replace(/\n/g, '\\n');
        content = content.replace(/"/g,  '\\"');
        return content;
	}
	this.scanner.scan(function(token, scanner) {
		if (scanner.stag == null)
		{
			switch(token) {
				case '\n':
					content = content + "\n";
					buff.push(put_cmd + '"' + clean(content) + '";');
					buff.cr()
					content = '';
					break;
				case scanner.left_delimiter:
				case scanner.left_equal:
				case scanner.left_comment:
					scanner.stag = token;
					if (content.length > 0)
					{

						buff.push(put_cmd + '"' + clean(content) + '"');
					}
					content = '';
					break;
				case scanner.double_left:
					content = content + scanner.left_delimiter;
					break;
				default:
					content = content + token;
					break;
			}
		}
		else {
			switch(token) {
				case scanner.right_delimiter:
					switch(scanner.stag) {
						case scanner.left_delimiter:
							if (content[content.length - 1] == '\n')
							{
								content = content.chop();
								buff.push(content);
								buff.cr();
							}
							else {
								buff.push(content);
							}
							break;
						case scanner.left_equal:
							buff.push(insert_cmd + "(EjsScanner.to_text(" + content + "))");
							break;
					}
					scanner.stag = null;
					content = '';
					break;
				case scanner.double_right:
					content = content + scanner.right_delimiter;
					break;
				default:
					content = content + token;
					break;
			}
		}
	});
	if (content.length > 0)
	{
		buff.push(put_cmd + '"' + clean(content) + '"');
	}
	buff.close();
	this.out = buff.script + ";";
	var to_be_evaled = 'this.process = function(_CONTEXT,_VIEW) { try { with(_VIEW) { with (_CONTEXT) {'+this.out+" return ___ejsO;}}}catch(e){e.lineNumber=null;throw e;}};";

	try{
		eval(to_be_evaled);
	}catch(e){
		if(typeof JSLINT != 'undefined'){
			JSLINT(this.out)
			for(var i = 0; i < JSLINT.errors.length; i++){
				var error = JSLINT.errors[i];
				if(error.reason != "Unnecessary semicolon."){
					error.line++;
					var e = new Error();
					e.lineNumber = error.line;
					e.message = error.reason;
					if(options.url)
						e.fileName = options.url;
					throw e;
				}
			}
		}else{
			throw e;
		}
	}
  }
}


EJS = function( options ){
  if(typeof options == 'string') {
    options = { text: options }
  }

	this.set_options(options)
	if(options.url){
		var template = EJS.get(options.url, this.cache)
		if (template) return template;
	    if (template == EJS.INVALID_PATH) return null;
		this.text = EJS.request(options.url)
		if(this.text == null){
			throw 'There is no template at '+options.url
		}
		this.name = options.url
	} else if(options.text) {
		this.text = options.text
		this.type = '<'
	} else if(options.element) {
		if(typeof options.element == 'string'){
			var name = options.element
			options.element = document.getElementById(  options.element )
			if(options.element == null) throw name+'does not exist!'
		}
		if(options.element.value){
			this.text = options.element.value
		}else{
			this.text = options.element.innerHTML
		}
		this.name = options.element.id
		this.type = '['
	}
	var template = new EjsCompiler(this.text, this.type);

	template.compile(options);

	EJS.update(this.name, this);
	this.template = template
}
EJS.config = function(options){
	EJS.cache = options.cache != null ? options.cache : EJS.cache
	EJS.type = options.type != null ? options.type : EJS.type
	var templates_directory = {} //nice and private container

	EJS.get = function(path, cache){
		if(cache == false) return null;
		if(templates_directory[path]) return templates_directory[path];
  		return null;
	}

	EJS.update = function(path, template) {
		if(path == null) return;
		templates_directory[path] = template
	}

	EJS.INVALID_PATH =  -1;


}
EJS.config( {cache: true, type: '<' } )

EJS.prototype = {
	render : function(object){
		var v = new EjsView(object);
		return this.template.process.call(v, object, v);
	},
	out : function(){
		return this.template.out
	},
	set_options : function(options){
		this.type = options.type != null ? options.type : EJS.type
		this.cache = options.cache != null ? options.cache : EJS.cache
		this.text = options.text != null ? options.text : null
		this.name = options.name != null ? options.name : null
	},
	update : function(element, options){
		if(typeof element == 'string'){
			element = document.getElementById(element)
		}
		if(options == null){
			_template = this;
			return function(object){
				EJS.prototype.update.call(_template, element, object)
			}
		}
		if(typeof options == 'string'){
			params = {}
			params.url = options
			_template = this;
			params.onComplete = function(request){
				var object = eval( request.responseText )
				EJS.prototype.update.call(_template, element, object)
			}
			EJS.ajax_request(params)
		}else
		{
			element.innerHTML = this.render(options)
		}
	}
}

	EJS.newRequest = function(){
	   var factories = [function() { return new ActiveXObject("Msxml2.XMLHTTP"); },function() { return new XMLHttpRequest(); },function() { return new ActiveXObject("Microsoft.XMLHTTP"); }];
	   for(var i = 0; i < factories.length; i++) {
	        try {
	            var request = factories[i]();
	            if (request != null)  return request;
	        }
	        catch(e) { continue;}
	   }
	}

	EJS.request = function(path){
	   var request = new EJS.newRequest()
	   request.open("GET", path, false);

	   try{request.send(null);}
	   catch(e){return null;}

	   if ( request.status == 404 || request.status == 2 ||(request.status == 0 && request.responseText == '') ) return null;

	   return request.responseText
	}
	EJS.ajax_request = function(params){
		params.method = ( params.method ? params.method : 'GET')

		var request = new EJS.newRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					params.onComplete(request)
				}else
				{
					params.onComplete(request)
				}
			}
		}
		request.open(params.method, params.url)
		request.send(null)
	}

Array.prototype.toSentence = function() {
  return this.join(', ');
};

Array.prototype.contains = function(object){
  for(var i = 0; i < this.length; i++) {
    if(this[i] === object) {
      return true;
    }
  }
  return false;
};

Array.prototype.intersect = function(other) {
	var result = [];
	for (var i = 0; i < this.length; i++) {
		if(other.contains(this[i])) {
			result.push(this[i]);
		}
  }
	return result;
}
/*
 * Date prototype extensions. Doesn't depend on any
 * other code. Doens't overwrite existing methods.
 *
 * Adds dayNames, abbrDayNames, monthNames and abbrMonthNames static properties and isLeapYear,
 * isWeekend, isWeekDay, getDaysInMonth, getDayName, getMonthName, getDayOfYear, getWeekOfYear,
 * setDayOfYear, addYears, addMonths, addDays, addHours, addMinutes, addSeconds methods
 *
 * Copyright (c) 2006 Jörn Zaefferer and Brandon Aaron (brandon.aaron@gmail.com || http://brandonaaron.net)
 *
 * Additional methods and properties added by Kelvin Luck: firstDayOfWeek, dateFormat, zeroTime, asString, fromString -
 * I've added my name to these methods so you know who to blame if they are broken!
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 */

/**
 * An Array of day names starting with Sunday.
 *
 * @example dayNames[0]
 * @result 'Sunday'
 *
 * @name dayNames
 * @type Array
 * @cat Plugins/Methods/Date
 */
Date.dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

/**
 * An Array of abbreviated day names starting with Sun.
 *
 * @example abbrDayNames[0]
 * @result 'Sun'
 *
 * @name abbrDayNames
 * @type Array
 * @cat Plugins/Methods/Date
 */
Date.abbrDayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

/**
 * An Array of month names starting with Janurary.
 *
 * @example monthNames[0]
 * @result 'January'
 *
 * @name monthNames
 * @type Array
 * @cat Plugins/Methods/Date
 */
Date.monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

/**
 * An Array of abbreviated month names starting with Jan.
 *
 * @example abbrMonthNames[0]
 * @result 'Jan'
 *
 * @name monthNames
 * @type Array
 * @cat Plugins/Methods/Date
 */
Date.abbrMonthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/**
 * The first day of the week for this locale.
 *
 * @name firstDayOfWeek
 * @type Number
 * @cat Plugins/Methods/Date
 * @author Kelvin Luck
 */
Date.firstDayOfWeek = 1;

/**
 * The format that string dates should be represented as (e.g. 'dd/mm/yyyy' for UK, 'mm/dd/yyyy' for US, 'yyyy-mm-dd' for Unicode etc).
 *
 * @name format
 * @type String
 * @cat Plugins/Methods/Date
 * @author Kelvin Luck
 */
Date.format = 'dd/mm/yyyy';

/**
 * The first two numbers in the century to be used when decoding a two digit year. Since a two digit year is ambiguous (and date.setYear
 * only works with numbers < 99 and so doesn't allow you to set years after 2000) we need to use this to disambiguate the two digit year codes.
 *
 * @name format
 * @type String
 * @cat Plugins/Methods/Date
 * @author Kelvin Luck
 */
Date.fullYearStart = '20';

(function() {

	/**
	 * Adds a given method under the given name
	 * to the Date prototype if it doesn't
	 * currently exist.
	 *
	 * @private
	 */
	function add(name, method) {
		if( !Date.prototype[name] ) {
			Date.prototype[name] = method;
		}
	};

	/**
	 * Checks if the year is a leap year.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.isLeapYear();
	 * @result true
	 *
	 * @name isLeapYear
	 * @type Boolean
	 * @cat Plugins/Methods/Date
	 */
	add("isLeapYear", function() {
		var y = this.getFullYear();
		return (y%4==0 && y%100!=0) || y%400==0;
	});

	/**
	 * Checks if the day is a weekend day (Sat or Sun).
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.isWeekend();
	 * @result false
	 *
	 * @name isWeekend
	 * @type Boolean
	 * @cat Plugins/Methods/Date
	 */
	add("isWeekend", function() {
		return this.getDay()==0 || this.getDay()==6;
	});

	/**
	 * Check if the day is a day of the week (Mon-Fri)
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.isWeekDay();
	 * @result false
	 *
	 * @name isWeekDay
	 * @type Boolean
	 * @cat Plugins/Methods/Date
	 */
	add("isWeekDay", function() {
		return !this.isWeekend();
	});

	/**
	 * Gets the number of days in the month.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.getDaysInMonth();
	 * @result 31
	 *
	 * @name getDaysInMonth
	 * @type Number
	 * @cat Plugins/Methods/Date
	 */
	add("getDaysInMonth", function() {
		return [31,(this.isLeapYear() ? 29:28),31,30,31,30,31,31,30,31,30,31][this.getMonth()];
	});

	/**
	 * Gets the name of the day.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.getDayName();
	 * @result 'Saturday'
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.getDayName(true);
	 * @result 'Sat'
	 *
	 * @param abbreviated Boolean When set to true the name will be abbreviated.
	 * @name getDayName
	 * @type String
	 * @cat Plugins/Methods/Date
	 */
	add("getDayName", function(abbreviated) {
		return abbreviated ? Date.abbrDayNames[this.getDay()] : Date.dayNames[this.getDay()];
	});

	/**
	 * Gets the name of the month.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.getMonthName();
	 * @result 'Janurary'
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.getMonthName(true);
	 * @result 'Jan'
	 *
	 * @param abbreviated Boolean When set to true the name will be abbreviated.
	 * @name getDayName
	 * @type String
	 * @cat Plugins/Methods/Date
	 */
	add("getMonthName", function(abbreviated) {
		return abbreviated ? Date.abbrMonthNames[this.getMonth()] : Date.monthNames[this.getMonth()];
	});

	/**
	 * Get the number of the day of the year.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.getDayOfYear();
	 * @result 11
	 *
	 * @name getDayOfYear
	 * @type Number
	 * @cat Plugins/Methods/Date
	 */
	add("getDayOfYear", function() {
		var tmpdtm = new Date("1/1/" + this.getFullYear());
		return Math.floor((this.getTime() - tmpdtm.getTime()) / 86400000);
	});

	/**
	 * Get the number of the week of the year.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.getWeekOfYear();
	 * @result 2
	 *
	 * @name getWeekOfYear
	 * @type Number
	 * @cat Plugins/Methods/Date
	 */
	add("getWeekOfYear", function() {
		return Math.ceil(this.getDayOfYear() / 7);
	});

	/**
	 * Set the day of the year.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.setDayOfYear(1);
	 * dtm.toString();
	 * @result 'Tue Jan 01 2008 00:00:00'
	 *
	 * @name setDayOfYear
	 * @type Date
	 * @cat Plugins/Methods/Date
	 */
	add("setDayOfYear", function(day) {
		this.setMonth(0);
		this.setDate(day);
		return this;
	});

	/**
	 * Add a number of years to the date object.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.addYears(1);
	 * dtm.toString();
	 * @result 'Mon Jan 12 2009 00:00:00'
	 *
	 * @name addYears
	 * @type Date
	 * @cat Plugins/Methods/Date
	 */
	add("addYears", function(num) {
		this.setFullYear(this.getFullYear() + num);
		return this;
	});

	/**
	 * Add a number of months to the date object.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.addMonths(1);
	 * dtm.toString();
	 * @result 'Tue Feb 12 2008 00:00:00'
	 *
	 * @name addMonths
	 * @type Date
	 * @cat Plugins/Methods/Date
	 */
	add("addMonths", function(num) {
		var tmpdtm = this.getDate();

		this.setMonth(this.getMonth() + num);

		if (tmpdtm > this.getDate())
			this.addDays(-this.getDate());

		return this;
	});

	/**
	 * Add a number of days to the date object.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.addDays(1);
	 * dtm.toString();
	 * @result 'Sun Jan 13 2008 00:00:00'
	 *
	 * @name addDays
	 * @type Date
	 * @cat Plugins/Methods/Date
	 */
	add("addDays", function(num) {
		this.setTime(this.getTime() + (num*86400000) );
		return this;
	});

	/**
	 * Add a number of hours to the date object.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.addHours(24);
	 * dtm.toString();
	 * @result 'Sun Jan 13 2008 00:00:00'
	 *
	 * @name addHours
	 * @type Date
	 * @cat Plugins/Methods/Date
	 */
	add("addHours", function(num) {
		this.setHours(this.getHours() + num);
		return this;
	});

	/**
	 * Add a number of minutes to the date object.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.addMinutes(60);
	 * dtm.toString();
	 * @result 'Sat Jan 12 2008 01:00:00'
	 *
	 * @name addMinutes
	 * @type Date
	 * @cat Plugins/Methods/Date
	 */
	add("addMinutes", function(num) {
		this.setMinutes(this.getMinutes() + num);
		return this;
	});

	/**
	 * Add a number of seconds to the date object.
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.addSeconds(60);
	 * dtm.toString();
	 * @result 'Sat Jan 12 2008 00:01:00'
	 *
	 * @name addSeconds
	 * @type Date
	 * @cat Plugins/Methods/Date
	 */
	add("addSeconds", function(num) {
		this.setSeconds(this.getSeconds() + num);
		return this;
	});

	/**
	 * Sets the time component of this Date to zero for cleaner, easier comparison of dates where time is not relevant.
	 *
	 * @example var dtm = new Date();
	 * dtm.zeroTime();
	 * dtm.toString();
	 * @result 'Sat Jan 12 2008 00:01:00'
	 *
	 * @name zeroTime
	 * @type Date
	 * @cat Plugins/Methods/Date
	 * @author Kelvin Luck
	 */
	add("zeroTime", function() {
		this.setMilliseconds(0);
		this.setSeconds(0);
		this.setMinutes(0);
		this.setHours(0);
		return this;
	});

	/**
	 * Returns a string representation of the date object according to Date.format.
	 * (Date.toString may be used in other places so I purposefully didn't overwrite it)
	 *
	 * @example var dtm = new Date("01/12/2008");
	 * dtm.asString();
	 * @result '12/01/2008' // (where Date.format == 'dd/mm/yyyy'
	 *
	 * @name asString
	 * @type Date
	 * @cat Plugins/Methods/Date
	 * @author Kelvin Luck
	 */
	add("asString", function(format) {
		var r = format || Date.format;
		return r
			.split('yyyy').join(this.getFullYear())
			.split('yy').join((this.getFullYear() + '').substring(2))
			.split('mmmm').join(this.getMonthName(false))
			.split('mmm').join(this.getMonthName(true))
			.split('mm').join(_zeroPad(this.getMonth()+1))
			.split('dd').join(_zeroPad(this.getDate()));
	});

	/**
	 * Returns a new date object created from the passed String according to Date.format or false if the attempt to do this results in an invalid date object
	 * (We can't simple use Date.parse as it's not aware of locale and I chose not to overwrite it incase it's functionality is being relied on elsewhere)
	 *
	 * @example var dtm = Date.fromString("12/01/2008");
	 * dtm.toString();
	 * @result 'Sat Jan 12 2008 00:00:00' // (where Date.format == 'dd/mm/yyyy'
	 *
	 * @name fromString
	 * @type Date
	 * @cat Plugins/Methods/Date
	 * @author Kelvin Luck
	 */
	Date.fromString = function(s)
	{
		var f = Date.format;
		var d = new Date('01/01/1977');

		var mLength = 0;

		var iM = f.indexOf('mmmm');
		if (iM > -1) {
			for (var i=0; i<Date.monthNames.length; i++) {
				var mStr = s.substr(iM, Date.monthNames[i].length);
				if (Date.monthNames[i] == mStr) {
					mLength = Date.monthNames[i].length - 4;
					break;
				}
			}
			d.setMonth(i);
		} else {
			iM = f.indexOf('mmm');
			if (iM > -1) {
				var mStr = s.substr(iM, 3);
				for (var i=0; i<Date.abbrMonthNames.length; i++) {
					if (Date.abbrMonthNames[i] == mStr) break;
				}
				d.setMonth(i);
			} else {
				d.setMonth(Number(s.substr(f.indexOf('mm'), 2)) - 1);
			}
		}

		var iY = f.indexOf('yyyy');

		if (iY > -1) {
			if (iM < iY)
			{
				iY += mLength;
			}
			d.setFullYear(Number(s.substr(iY, 4)));
		} else {
			if (iM < iY)
			{
				iY += mLength;
			}
			d.setFullYear(Number(Date.fullYearStart + s.substr(f.indexOf('yy'), 2)));
		}
		var iD = f.indexOf('dd');
		if (iM < iD)
		{
			iD += mLength;
		}
		d.setDate(Number(s.substr(iD, 2)));
		if (isNaN(d.getTime())) {
			return false;
		}
		return d;
	};

	var _zeroPad = function(num) {
		var s = '0'+num;
		return s.substring(s.length-2)
	};

})();
/*
	parseUri 1.2.1
	(c) 2007 Steven Levithan <stevenlevithan.com>
	modified by Clemens Kofler <clemens@railway.at> for adva-cms (added namespacing)
	MIT License
*/

var URI = {};

URI.parse = function(str) {
	var	o   = URI.parseOptions,
		m   = o.parser[o.strictMode ? "strict" : "loose"].exec(str),
		uri = {},
		i   = 14;

	while (i--) uri[o.key[i]] = m[i] || "";

	uri[o.q.name] = {};
	uri[o.key[12]].replace(o.q.parser, function ($0, $1, $2) {
		if ($1) uri[o.q.name][$1] = $2;
	});

	return uri;
};

URI.parseOptions = {
	strictMode: false,
	key: ["source","protocol","authority","userInfo","user","password","host","port","relative","path","directory","file","query","anchor"],
	q:   {
		name:   "queryKey",
		parser: /(?:^|&)([^&=]*)=?([^&]*)/g
	},
	parser: {
		strict: /^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*):?([^:@]*))?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/,
		loose:  /^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*):?([^:@]*))?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/
	}
};

$(document).ready(function() {
  $("body").bind('ajaxSend', function(elm, xhr, s) {
    if (s.type == 'GET') return;
    if (s.data && s.data.match(new RegExp("\\b" + window._auth_token_name + '='))) return;
    if (s.data) {
      s.data = s.data + '&';
    } else {
      s.data = '';
      xhr.setRequestHeader('Content-Type', s.contentType);
    }
    s.data += encodeURIComponent(window._auth_token_name) + '=' +
              encodeURIComponent(window._auth_token);
  });
});

(function($) {
  $.fn.outerHTML = function() {
    return $('<div>').append( this.eq(0).clone() ).html();
  };

  $.fn.delay = function(time, name) {
    return this.queue((name || "fx"), function() {
      var self = this;
      setTimeout(function() { $.dequeue(self); } , time );
    });
  };
})(jQuery);
Resource = function(type, element) {
	if(element) {
		this.type = type;
		this.element = element;
		Resource.register(this);
	}
};

$.extend(Resource, {
  types: [],
	type_names: function() {
		var type_names = $.map(this.types, function(type) {
			return type.type_name();
		});
		this.type_names = function() { return type_names; }
		return type_names;
	},
	type_map: function() {
		var map = {}
		for(var i = 0; i < Resource.types.length; i++) {
			map[Resource.types[i].class_name()] = Resource.types[i];
		}
		this.type_map = function() { return map; }
		return map;
	},
	class_names: function() {
		var class_names = $.map(this.type_names(), function(name) { return name.toLowerCase(); })
		this.class_names = function() { return class_names; }
		return class_names;
	},
	type_name: function() {
		var matches = this.toString().match(/Resource.call\(this, ([\w]*), element\)/);
		this.type_name = function() { return matches[1]; }
		return matches[1];
	},
	class_name: function() {
		var class_name = this.type_name().toLowerCase();
		this.class_name = function() { return class_name; }
		return class_name;
	},
	collection_name: function() {
	  var collection_name = this.class_name() + 's'; // FIXME
	  this.collection_name = function() { return collection_name; }
	  return collection_name;
	},
	collection_path: function() {
	  return '/' + this.collection_name();
	},
	member_path: function(resource) {
	  return '/' + this.collection_name() + '/' + resource.id();
	},
	elements: function() {
		return $(this.selector);
	},
	all: function() {
		var type = this;
		return objects = this.elements().map(function() {
			return $(this).resource(type)
		});
	},
	init: function() {
		$.each(this.all(), function() {
			if(this.init) this.init();
			this.bind_events();
		})
	},
	register: function(resource) {
		resource.element.data('resource', resource);
	},
	remove: function(resource) {
		resource.element.data('resource', null);
	},
	lookup: function(element) {
		return element.data('resource');
	},
	get: function(type, elements) {
		var resources = []; // FIXME return a jquery Object instead
		for(var i = 0; i < elements.length; i++) {
			var element = elements.eq(i);
			var resource = this.lookup(element);
			resources.push(resource ? resource : new type(element));
		}
		return elements.length == 1 ? resources[0] : resources;
	},
	id: function(element) {
	}
});

Resource.prototype = {
	id: function() {
		var source = this.element.attr('id');
		source = source ? source : this.element.attr('href');

    var regexp = new RegExp('[' + this.type.collection_name() + '|' + this.type.class_name() + ']' + '[/_](\\d+)$');
		var matches = source ? source.match(regexp) : null;
		return matches ? matches[1] : null;
	},
  is_new_record: function() {
    return this.id() == null;
  },
	plan_id: function() {
	  var plan = $('#plan');
	  if(plan.size() > 0) {
	    return plan.attr('class').match(/plan_(\d+)/)[1];
    }
	},
	href: function() {
		return this.element.attr('href');
	},
	class_names: function() {
		return this.element.attr('class').split(/\s+/);
	},
	dom_id: function() {
	  if(this.id()) {
		  return this.type.class_name() + '_' + this.id();
		}
	},
  top: function() {
		if(arguments.length == 0) {
			return parseInt(this.element.css('top'));
		} else {
			this.element.css('top', arguments[0] + 'px');
		}
  },
	left: function() {
		if(arguments.length == 0) {
			return parseInt(this.element.css('left'));
		} else {
			this.element.css('left', arguments[0] + 'px');
		}
	},
	width: function() {
		if(arguments.length == 0) {
			return parseInt(this.element.css('width'));
		} else {
			this.element.css('width', arguments[0] + 'px');
		}
	},
	height: function() {
		if(arguments.length == 0) {
			return parseInt(this.element.css('height'));
		} else {
			this.element.css('height', arguments[0] + 'px');
		}
	},
  click_cancelled: function() {
		if(arguments.length == 0) {
			return this.element.data('click_cancelled');
		} else {
			this.element.data('click_cancelled', arguments[0]);
		}
  },
	remove: function(element) {
		this.element.remove();
		return Resource.remove(this);
	},
  save: function() {
	  if(this.is_new_record()) {
	    var url  = this.type.collection_path();
	    var type = 'post';
	  } else {
	    var url  = this.type.member_path(this);
	    var type = 'put';
	  }

    var data = 'plan_id=' + this.plan_id() + '&' + this.serialize(); // FIXME not good, but the simplest thing at the moment

		$.ajax({
		  'url': url,
		  'type': type,
		  'data': data,
		  'dataType': 'text',
		  'success': this.is_new_record() ? this.on_create : this.on_update
		});
	},
	destroy: function() {
	  var url = this.type.member_path(this);
	  var data = '_method=delete';
    if(this.plan_id()) {
      data += '&plan_id=' + this.plan_id();
    }

	  $.ajax({
		  'url': url,
		  'type': 'post', // seems like HTMLUnit doesn't allow DELETE requests to have parameters ...
		  'data': data,
		  'dataType': 'text',
		  'success': this.on_destroy
		});
	},
 	on_destroy: function(data, textStatus) {
    data = eval("(" + data + ")");
    if(data['flash']) {
      $.each(data['flash'], function(type, message) {
        if(message != '') {
          $('#flash').html(message).attr('class', type).show().delay(3000).fadeOut(2000);
        }
      });
    }
 	}
};

$.extend($.fn, {
	resource: function(type) {
		if(type == undefined) {
			type = this.resource_type();
		}
		var element = this.closest(type.selector);
		if(element.length == 0) {
			throw('Could not find any (parent) element matching the selector ' + type.selector + '.');
		}
		return Resource.get(type, element);
	},
	resource_type: function() {
		return Resource.type_map()[this.resource_class_name()];
	},
	resource_class_name: function() {
		var class_names = this.attr('className').split(' ')
		class_names = class_names.intersect(Resource.class_names());
		if(class_names.length > 1) {
			throw("multiple resource type class names found: " + class_names.join(', '))
		}
		return class_names[0];
	}
});

$(document).ready(function() {
  $.each(Resource.types, function() {
  	var type = this;
  	$.fn[this.class_name()] = function() { return this.resource(type); }
  });
  $.each(Resource.types, function() {
    this.init();
  });
})

Cursor = {
	show: function(html_class) {
	  var cursor = $('#cursor');
	  if(cursor.length == 0) {
      cursor = $('body').append('<div id="cursor" class="' + html_class + '"></div>');
	  }
    cursor.show();
	},
	hide: function() {
    $('#cursor').hide();
	},
	update_position: function(left, top) {
    $('#cursor').css({ left: left, top: top });
	},
  poof: function() {
    $('.poof').show()
    var top = 32;
  	for(i = 1; i < 5; i++) {
  		$('.poof').animate({ backgroundPosition: '0 ' + (top -= 32) + 'px' }, 80);
  	}
  	setTimeout("$('.poof').hide().css({ backgroundPosition: '0 0px' })", 5 * 80);
  }
};
Plan = {
	slot_width: 18,
	slots_per_hour: 4,
	default_slot_count: 12,
	init: function() {
    $('#main').css({ width: Plan.width() + 12 + 'px' });
    $('#plan').css({ width: Plan.width() + 'px' });
    this.bind_events();
	},
	bind_events: function() {
		$("body").droppable({
			accept: ".requirement, .assignment",
			drop: Plan.on_element_remove,
		});
	},
	start: function() {
		return parseInt($('#plan').attr("data-start"));
	},
  duration: function() {
    return parseInt($('#plan').attr("data-duration"));
  },
  end: function() {
    return this.start() + this.duration();
  },
  hours: function() {
    return parseInt(this.duration() / 60);
  },
  width: function() {
    return Plan.hours() * Plan.slots_per_hour * Plan.slot_width + 1;
  },
	minutes_per_slot: function() {
		return parseInt(60 / Plan.slots_per_hour);
	},
	pixels_per_hour: function() {
		return Plan.slot_width * Plan.slots_per_hour;
	},
	pixels_per_minute: function() {
		return Plan.pixels_per_hour() / 60;
	},
	on_element_remove: function(event, ui) {
		ui.draggable.resource().remove();
	}
};
Plan.grid = [Plan.slot_width, 38],

$(document).ready(function() {
  if($('#plan').length > 0) Plan.init();
});

(function() {
  Day = function(element) {
  	Resource.call(this, Day, element);
  };

  $.extend(Day, Resource, {
  	selector: '.day',
  	on_drop: function(event, ui) {
  		switch(true) {
  			case ui.draggable.parent().hasClass('workplace'):
  				Day.on_workplace_drop.call(this, event, ui);
  				break;
  			default:
  				Plan.on_element_remove(event, ui);
  				break;
  		}
  	},
  	on_workplace_drop: function(event, ui) {
      Shifts.on_workplace_drop.call(this, event, ui);
  	}
  });

  Day.prototype = $.extend(new Resource, {
    init: function() {
      this.render_hours();
    },
    find_shifts: function(workplace) {
      var element = $('.' + workplace.dom_id(), this.element)[0];
      if(element) return $(element).shifts();
    },
    append_shifts: function (workplace) {
      var shifts = $('<ul class="workplace ' + workplace.dom_id() + ' shifts"></ul>');
      this.element.append(shifts);
      return shifts.shifts();
    },
  	append_shift: function(day, left, width) {
  		shift.element.css({ left: left });
  		shift.width(width);
  		shift.update_data_from_dimension();
  		this.element.append(shift.element);
  	},
    bind_events: function() {
      this.element.droppable({
       accept: "#workplaces a div, #plan .requirement, #plan .assignment",
       tolerance: 'touch',
       greedy: true,
       drop: Day.on_drop
      });
    },
    render_hours: function() {
      return
      var hours = $('<ul class="hours">');
      this.element.after(hours);
      for(var i = Plan.start(); i < Plan.end(); i += 60) {
        var hour = $('<li class="hour">' + (i / 60) + '</li>').css({
          width: Plan.pixels_per_hour()
        });
        hours.append(hour).css;
      }
    },
  });

  Resource.types.push(Day);

}.apply(Plan));

(function() {
  Shifts = function(element) {
  	Resource.call(this, Shifts, element);
  };

  $.extend(Shifts, Resource, {
  	selector: '.shifts',
  	on_drop: function(event, ui) {
  		switch(true) {
  			case ui.draggable.parent().hasClass('workplace'):
  				Shifts.on_workplace_drop.call(this, event, ui);
  				break;
  			default:
  				Plan.on_element_remove(event, ui);
  				break;
  		}
  	},
  	on_workplace_drop: function(event, ui) {
      var day = $(this).day();
      var workplace = ui.draggable.workplace();
      var shifts = day.find_shifts(workplace) || day.append_shifts(workplace);

      var left = parseInt(ui.offset.left - this.offsetLeft - 1);
      left = left - (left % Plan.slot_width);
      var width = workplace.default_shift_length() ?
        workplace.default_shift_length() * Plan.pixels_per_minute() :
        Plan.slot_width * Plan.default_slot_count;
      if(left + width > this.offsetWidth) {
        width = this.offsetWidth - left - 1;
      }

      var shift = shifts.append_shift(workplace, left, width);
      shift.save();
      shifts.adjust_shift_positions();
  	}
  });

  Shifts.prototype = $.extend(new Resource, {
    init: function() {
      this.adjust_shift_positions();
    },
    day: function() {
      return this.element.closest('.day').day();
    },
    empty: function() {
      return $('.shift', this.element).length == 0;
    },
  	append_shift: function(workplace, left, width) {
  		var shift = Shift.build(workplace);
  		shift.element.css({ position: 'absolute' }); // draggable adds position: relative
  		shift.left(left);
  		shift.width(width);
  		shift.update_data_from_dimension();
  		this.element.append(shift.element);

  		shift.bind_events();
  		$('.requirement', shift.element).each(function() { $(this).requirement().bind_events(); })
      return shift;
  	},
    adjust_shift_positions: function() {
      var last = null;
      $('.shift', this.element).each(function() {
        var shift = $(this).shift();
        var offset = last && (last.end() > shift.start()) ? 37 : 0;
        shift.top((last ? last.top() : 0) + offset);
        last = shift;
      });
      this.adjust_height();
    },
    adjust_height: function() {
      var max_height = 38;
      $('.shift', this.element).each(function() {
        var height = $(this).shift().top() + 38;
        if(max_height < height) max_height = height;
      });
      this.height(max_height);
    },
    bind_events: function() {
      this.element.droppable({
       accept: "#workplaces a div, #plan .requirement, #plan .assignment",
       tolerance: 'touch',
       greedy: true,
       drop: Shifts.on_drop
      });
    },
  });

  Resource.types.push(Shifts);

}.apply(Plan));


(function() {
  Shift = function(element) {
  	Resource.call(this, Shift, element);
  };

  $.extend(Shift, Resource, {
  	selector: '.shift',
  	build: function(workplace) {
  		var template = new EJS({ url: '/javascripts/shiftplan/plan/shift/new_shift.ejs' })
  		var html = template.render({
  		  workplace: workplace,
  		  default_staffing: workplace.default_staffing()
  		});

  		var shift = $(html).shift();
  		shift.init();
  		return shift;
  	},
  	pixels_to_minutes: function(pixels) {
  		return pixels / Plan.pixels_per_minute();
  	},
  	minutes_to_pixels: function(minutes) {
  		return minutes * Plan.pixels_per_minute();
  	},
    on_mousedown: function(event) {
      $(this).shift().click_cancelled(false);
    },
  	on_click: function(event) {
  	  var shift = $(this).shift();
      if(shift.click_cancelled()) return;

	    $('#sidebar .employee').removeClass('suitable').removeClass('unsuitable');

  	  if(shift.selected()) {
  	    shift.element.removeClass('selected');
  	  } else {
  	    $('#plan .selected').removeClass('selected');
  	    shift.element.addClass('selected');
  	    shift.suitable_employees().addClass('suitable');
  	    shift.unsuitable_employees().addClass('unsuitable');
  	  }
  	},
  	on_drag_stop: function(event, ui) {
  	  var shift = ui.helper.shift();
  	  if(shift.removing) {
  	    shift.remove();
  	    Cursor.hide();
        Cursor.poof();
  	  } else {
    		shift.update_data_from_dimension();
        shift.shifts().adjust_shift_positions();
    		shift.save(); // TODO only save if modified
    	}
      event.stopPropagation();
      shift.click_cancelled(true);
  	},
  	on_resize: function(event, ui) {
  		var shift = $(this).shift();
  		var draggable = $(this).data('draggable');
  		shift.init_containment(draggable);

  		if($(this).hasClass('left')) {
  			shift.left(shift.left() + ui.position.left);
  			shift.width(shift.width() - ui.position.left);
  			draggable.offset.parent.left = draggable.offset.parent.left + ui.position.left;
  		} else {
  			shift.width(ui.position.left + ui.helper.width());
  		}
  	},
  	on_qualification_drop: function(event, ui) {
  		$(this).shift().add_requirement($(ui.draggable).qualification());
  	}
  });

  Shift.prototype = $.extend(new Resource, {
    init: function() {
      var handles = $('<span class="resize_handle left"></span><span class="resize_handle right"></span>');
      this.element.append(handles);
      this.update_dimension_from_data();
    },
    shifts: function() {
      return this.element.closest('.shifts').shifts();
    },
    selected: function() {
      return this.element.hasClass('selected');
    },
    suitable_employees: function() {
      return $('#sidebar .employee[data-possible-workplaces*=workplace_' + this.workplace_id() +']');
    },
    unsuitable_employees: function() {
      return $('#sidebar .employee:not([data-possible-workplaces*=workplace_' + this.workplace_id() +'])');
    },
  	init_containment: function(draggable) { // gotta set containment directly to the draggable
  		if (!draggable.containment) {
  			draggable.containment = this.containment();
  		}
  	},
  	containment: function() {
  		var container = this.container();
  		var left = container.position().left;
  		var top = this.element.position().top;
  		return [left, top, left + container.width(), top + this.element.height()];
  	},
  	container: function() {
  		return this.element.closest('.shifts');
  	},
  	workplace_id: function() {
  	  if(arguments.length == 0) {
  			return parseInt(this.element.attr('data-workplace-id'));
  		} else {
  			this.element.attr('data-workplace-id', arguments[0]);
  		}
  	},
  	day: function() {
  	  return this.element.closest('.day').attr('data-day'); // hmmm?
  	},
  	start: function() {
  		if(arguments.length == 0) {
  			return parseInt(this.element.attr('data-start'));
  		} else {
  			this.element.attr('data-start', arguments[0]);
  		}
  	},
    end: function() {
      return this.start() + this.duration();
    },
  	duration: function() {
  		if(arguments.length == 0) {
  			return parseInt(this.element.attr('data-duration'));
  		} else {
  			this.element.attr('data-duration', arguments[0]);
  		}
  	},
  	serialize: function() {
  	  return 'shift[workplace_id]=' + this.workplace_id() +
             '&shift[day]=' + this.day() +
             '&shift[start]=' + this.start() +
             '&shift[duration]=' + this.duration();
  	},
  	remove: function() {
      var shifts = this.shifts();
  	  this.destroy();
  	  Resource.prototype.remove.call(this);
      shifts.empty() ? shifts.remove() : shifts.adjust_shift_positions();
  	},
  	add_requirement: function(qualification) {
  		var element = $('<li class="requirement"></li>');
  		$('.requirements', this.element).append(element);
  		var requirement = element.requirement();
  		requirement.add_qualification(qualification);
  		requirement.save();
  		requirement.bind_events();
  	},
  	update_dimension_from_data: function() {
  		this.left(Shift.minutes_to_pixels(this.start() - Plan.start()));
  		this.width(Shift.minutes_to_pixels(this.duration()));
  	},
  	update_data_from_dimension: function() {
  		this.element.attr({
  			'data-start': Shift.pixels_to_minutes(this.left()) + Plan.start(),
  			'data-duration': Shift.pixels_to_minutes(this.width())
  		});
  	},
  	expand_animated: function(width) {
  		this.element.animate({ width: width }, {
  			complete: function() { $(this).shift().update_data_from_dimension(); }
  		});
  	},
  	draggable: function() {
  	  return this.element.data('draggable');
  	},
  	shiftsDimensions: function() {
      if(!this.element.data('shiftsDimensions')) {
        var containment = this.element.data('draggable').containment;
        this.element.data('shiftsDimensions', {
          left:   containment[0] - 5,
          top:    containment[1] - 5,
          right:  containment[2] + this.element.width() + 5,
          bottom: containment[3] + this.element.height() + 5
        });
      }
      return this.element.data('shiftsDimensions');
  	},
  	shiftsDimensions: function() {
      if(!this.element.data('shiftsDimensions')) {
        var day = this.element.closest('.day')[0];
        this.element.data('shiftsDimensions', {
          left:   day.offsetLeft - 10,
          top:    day.offsetTop - 10,
          right:  day.offsetLeft + day.offsetWidth + 10,
          bottom: day.offsetTop + day.offsetHeight + 10
        });
      }
      return this.element.data('shiftsDimensions');
  	},
  	isOverShiftsBox: function(event) {
      var box = this.shiftsDimensions();
      return event.pageX >= box.left && event.pageX <= box.right &&
             event.pageY >= box.top  && event.pageY <= box.bottom

  	},
  	updateDragMode: function(event) {
      var over = this.isOverShiftsBox(event);
      if(over) {
        this.setDragAdjusting(event);
      } else if(!over) {
        this.setDragRemoving(event);
        Cursor.update_position(event.pageX, event.pageY + 10)
      }
  	},
  	setDragAdjusting: function(event) {
  	  if(this.removing) {
        this.removing = false;
  	    this.element[0].style.top = '0px';
  	    var draggable = this.draggable();
  	    $.extend(true, draggable, {
  	      containment: 'parent',
  	      options: { axis: 'x', grid: Plan.grid }
  	    });
  	    draggable._setContainment();
  	    Cursor.hide();
      }
  	},
  	setDragRemoving: function(event) {
  	  if(!this.removing) {
        this.removing = true;
  	    $.extend(true, this.draggable(), {
  	      containment: null,
  	      options: { axis: null, grid: null }
  	    });
        Cursor.show('poof');
      }
  	},
  	bind_events: function() {
      this.element.mousedown(Shift.on_mousedown);
      this.element.click(Shift.on_click);
      this.element.droppable({
        accept: "#qualifications a div",
        drop: Shift.on_qualification_drop
      });

      this.element.draggable({
        containment: 'parent',
        axis: 'x',
        grid: Plan.grid,
        stop: function(event, ui) {
          ui.helper.data('shiftsDimensions', null);
          Shift.on_drag_stop(event, ui);
        },
        drag: function(event, ui) {
          ui.helper.shift().updateDragMode(event);
        }
      });
      $(".resize_handle", this.element).draggable({
        axis: 'x',
        grid: Plan.grid,
        drag: Shift.on_resize,
        stop: Shift.on_drag_stop
      });
      $(".resize_handle", this.element).css('position', null);
  	},
  	on_create: function(data, textStatus) {
      data = eval("(" + data + ")");
  	  var shift_id = 'shift_' + data['shift']['id'];
  	  var shift = $('#new_shift').attr('id', shift_id);
  	  $('.requirement', shift).each(function(index) {
  	    $(this).attr('id', 'requirement_' + data['shift']['requirements'][index]['id']);
  	  });
  	},
  	on_update: function(data, textStatus) {
      data = eval("(" + data + ")");
  	},
  	on_destroy: function(data, textStatus) {
      data = eval("(" + data + ")");
  	},
  });

  Resource.types.push(Shift);

}.apply(Plan));
(function() {
  Requirement = function(element) {
  	Resource.call(this, Requirement, element);
  };

  $.extend(Requirement, Resource, {
  	selector: ".requirement",
  	on_employee_drop: function(event, ui) {
  		var requirement = $(this).requirement();
  		var employee = $(ui.draggable).employee()
  		var assignment = requirement.assign_employee(employee);
  		assignment.element.effect('bounce', {}, 100);
  	},
  	on_click: function(event) {
  	  event.preventDefault();
  	  event.stopPropagation();
  	  var requirement = $(this).requirement();

	    $('#sidebar .employee').removeClass('suitable').removeClass('unsuitable');

  	  if(requirement.selected()) {
  	    requirement.element.removeClass('selected');
  	  } else {
  	    $('#plan .selected').removeClass('selected');
  	    requirement.element.addClass('selected');
  	    requirement.suitable_employees().addClass('suitable');
  	    requirement.unsuitable_employees().addClass('unsuitable');
  	  }
  	}
  });

  Requirement.prototype = $.extend(new Resource, {
    shift: function() {
      return this.element.closest('.shift').shift();
    },
    qualification_id: function() {
      var matches = this.element.attr('class').match(/qualification_(\d+)/);
      if(matches) return matches[1];
    },
  	assign_employee: function(employee) {
  	  var assignment = $(Assignment.selector, this.element);

  	  if(assignment.size() > 0) {
  	    var assignment = assignment.assignment();
  	    assignment.element.removeClass('employee_' + assignment.employee_id()).addClass(employee.dom_id());
  	  } else {
    		element = $('<a class="assignment ' + employee.dom_id() + '" href="#"></a>');
    		this.element.append(element);
    		var assignment = $(element).assignment();
  	  }

  		assignment.save();
  		assignment.bind_events();
  		return assignment;
  	},
  	add_qualification: function(qualification) {
  		if(qualification.dom_id()) {
  			this.element.addClass(qualification.dom_id());
  		}
  	},
  	bind_events: function() {
  		this.element.draggable({
  			helper: 'clone'
  		});
  		this.element.droppable({
  			accept: ".employee div",
  			drop: Requirement.on_employee_drop
  		});
  		this.element.click(Requirement.on_click)
  	},
    selected: function() {
      return this.element.hasClass('selected');
    },
    suitable_employees: function() {
      return $('#sidebar .employee[data-qualifications*=qualification_' + this.qualification_id() +']');
    },
    unsuitable_employees: function() {
      return $('#sidebar .employee:not([data-qualifications*=qualification_' + this.qualification_id() +'])');
    },
  	remove: function() {
  	  this.destroy();
  	  Resource.prototype.remove.call(this);
  	},
  	serialize: function() {
  	  return 'requirement[shift_id]=' + this.shift().id() +
             '&requirement[qualification_id]=' + this.qualification_id();
  	},
   	on_create: function(data, textStatus) {
      data = eval("(" + data + ")");
   	  $('#shift_' + data['requirement']['shift_id'] + ' .requirement:not([id])').
   	    attr('id', 'requirement_' + data['requirement']['id']);
   	},
   	on_update: function(data, textStatus) {
      data = eval("(" + data + ")");
   	},
   	on_destroy: function(data, textStatus) {
      data = eval("(" + data + ")");

      if(data['flash']) {
        $.each(data['flash'], function(type, message) {
          if(message != '') {
            $('#flash').html(message).attr('class', type).show().delay(3000).fadeOut(2000);
          }
        });
      }
   	}
  });

  Resource.types.push(Requirement);

}.apply(Plan));

(function() {
  Assignment = function(element) {
  	Resource.call(this, Assignment, element);
  };

  $.extend(Assignment, Resource, {
  	selector: ".assignment",
  });

  Assignment.prototype = $.extend(new Resource, {
    requirement: function() {
      return this.element.closest('.requirement').requirement();
    },
    assignee_id: function() {
      var matches = this.element.attr('class').match(/employee_(\d+)/);
      if(matches) return matches[1];
    },
  	bind_events: function() {
  		this.element.draggable({
  			helper: 'clone'
  		});
  	},
  	remove: function() {
  	  this.destroy();
  	  Resource.prototype.remove.call(this);
  	},
  	serialize: function() {
  	  return 'assignment[requirement_id]=' + this.requirement().id() +
  	         '&assignment[assignee_id]=' + this.assignee_id();
  	},
  	on_create: function(data, textStatus) {
      data = eval("(" + data + ")");
  	  $('#requirement_' + data['assignment']['requirement_id'] + ' .assignment').attr('id', 'assignment_' + data['assignment']['id']);
  	},
  	on_update: function(data, textStatus) {
      data = eval("(" + data + ")");
  	}
  });

  Resource.types.push(Assignment);
}.apply(Plan));
(function() {
  Employee = function(element) {
  	Resource.call(this, Employee, element);
  };

  $.extend(Employee, Resource, {
  	selector: ".employee",
  	on_drag_start: function(event, ui) {
      var workplaces = ui.helper.closest('.employee').attr('data-possible-workplaces');
      if(workplaces.length != 0) {
        workplaces = $.map(workplaces.split(/,\s?/), function(workplace) {
          return '.' + workplace;
        });
        $('.shift:not(' + workplaces.join(',') + ')').addClass('unsuitable_workplace');
      }
  	},
  	on_drag_stop: function(event, ui) {
      $('.unsuitable_workplace').removeClass('unsuitable_workplace');
  	}
  });

  Employee.prototype = $.extend(new Resource, {
    init: function() {
      this.element.prepend('<div></div>')
    },
  	bind_events: function() {
  		$('div', this.element).draggable({
  			helper: 'clone',
  			start: Employee.on_drag_start,
  			stop: Employee.on_drag_stop
  		});
  	}
  });

  Resource.types.push(Employee);

}.apply(Plan));
(function() {
  Workplace = function(element) {
  	Resource.call(this, Workplace, element);
  };

  $.extend(Workplace, Resource, {
  	selector: ".workplace",
  });

  Workplace.prototype = $.extend(new Resource, {
    default_staffing: function() {
      return eval(this.element.attr('data-default-staffing'));
    },
    default_shift_length: function() {
      return parseInt(this.element.attr('data-default-shift-length'));
    },
    init: function() {
      this.element.prepend('<div></div>')
    },
  	bind_events: function() {
  		$('div', this.element).draggable({
  			helper: 'clone',
  		});
  	},
  	name: function() {
  		return this.element[0].innerHTML.replace(/<\/?[^>]+>/gi, '');
  	},
  });

  Resource.types.push(Workplace);

}.apply(Plan));
(function() {
  Qualification = function(element) {
  	Resource.call(this, Qualification, element);
  };

  $.extend(Qualification, Resource, {
  	selector: ".qualification",
  	on_drag_start: function(event, ui) {
  	},
  	on_drag_stop: function(event, ui) {
  	  $('.unsuitable_workplace').removeClass('unsuitable_workplace');
  	}
  });

  Qualification.prototype = $.extend(new Resource, {
    init: function() {
      this.element.prepend('<div></div>')
    },
  	bind_events: function() {
  		$('div', this.element).draggable({
  			helper: 'clone',
  			start: Qualification.on_drag_start,
  			stop: Qualification.on_drag_stop
  		});
  	}
  });

  Resource.types.push(Qualification);

}.apply(Plan));
$(document).ready(function() {
  $('input#employee_search_query').quicksearch('#employee_search table tbody tr');
  $('input#workplace_search_query').quicksearch('#workplace_search table tbody tr');
  $('input#qualification_search_query').quicksearch('#qualification_search table tbody tr');

  $('#sidebar a.show_search').click(function(event) {
    event.preventDefault();

    var resource   = this.id.match(/show_(.*)_search/)[1];
    var search_box = $('#' + resource + '_search');

    $('#sidebar .' + resource + ':not(.hidden)').each(function(idx, selected) {
      var dom_id = $(selected)[resource]().dom_id();
      $('.' + dom_id + ' input[type=checkbox]', search_box).attr('checked', 'checked');
    });

    search_box.show();
  });

  $('.search_box .close').click(function(event) {
    event.preventDefault();

    var search_box = $(this).closest('.search_box');

    search_box.find('input[type=checkbox]').each(function() {
      var checkbox = $(this);
      var resource = $('#sidebar .' + checkbox.closest('tr').attr('class'));
      checkbox.is(':checked') ? resource.removeClass('hidden') : resource.addClass('hidden');
    });

    search_box.hide();
  });

  $('.search_box .select_all').click(function(event) {
    event.preventDefault();
    $(this).closest('.search_box').find('input[type=checkbox]').attr('checked', 'checked');
  });

  $('.search_box .deselect_all').click(function(event) {
    event.preventDefault();
    $(this).closest('.search_box').find('input[type=checkbox]').removeAttr('checked');
  });
});
$(document).ready(function() {
  $('.status a.edit, .status a.add').live('click', function(event) {
    var status = $(this).closest('.resource');
    if(status.hasClass('default')) {
      $('.override_only').hide();
      $('.override_only input, .override_only select, .override_only textarea').attr('disabled', 'disabled');
      $('.default_only input, .default_only select, .default_only textarea').removeAttr('disabled');
      $('.default_only').show();
    } else {
      $('.default_only').hide();
      $('.default_only input, .default_only select, .default_only textarea').attr('disabled', 'disabled');
      $('.override_only input, .override_only select, .override_only textarea').removeAttr('disabled');
      $('.override_only').show();
    }
  });
});
$(document).ready(function() {
  $('#sidebar form').ajaxForm({
    dataType: 'text',
    success: function(data, textStatus) {
      data = eval("(" + data + ")");

      $('#sidebar form').each(function() { this.reset(); });
      $('#staff_requirements').each(function() { $(this).empty(); })
      $('#copy_from_options').hide();

      if(data['html']) {
        if(data['html']['append']) {
          $.each(data['html']['append'], function(element, html) {
            $(html).appendTo($(element)).effect('highlight', {}, 1000);
          });
        }

        if(data['html']['replace']) {
          $.each(data['html']['replace'], function(element, html) {
            $(html).replaceAll($(element)).effect('highlight', {}, 1000);
          });
        }
      }

      if(data['flash']) {
        $.each(data['flash'], function(type, message) {
          if(message != '') {
            $('#flash').html(message).attr('class', type).show().delay(3000).fadeOut(2000);
          }
        });
      }
    }
  });
});
$(document).ready(function() {
  $('.resource .actions a.delete').live('click', function(event) {
    event.preventDefault();
    event.stopPropagation();

    var resource = $(this).closest('.resource')[0];
    var match = resource.id.match(/(.*)_(\d+)/);
    var resource_name = match[1];

    if($(this).attr('data-confirm')) {
      if(!confirm($(this).attr('data-confirm'))) {
        return false;
      }
    }

    if(resource_name == 'plan') { // yuck FIXME
      var url = '/plans/' + match[2];
  	  var data = '_method=delete';

  	  $.ajax({
  		  'url': url,
  		  'type': 'post', // seems like HTMLUnit doesn't allow DELETE requests to have parameters ...
  		  'data': data,
  		  'dataType': 'text',
  		  'success': function(data, textStatus) {
  		    $(resource).remove();
          data = eval("(" + data + ")");
          if(data['flash']) {
            $.each(data['flash'], function(type, message) {
              if(message != '') {
                $('#flash').html(message).attr('class', type).show().delay(3000).fadeOut(2000);
              }
            });
          }
        }
  		});
    } else {
      $(resource)[resource_name]().destroy();
      $(resource).remove();
    }
  });

  $('li.resource, .resource .actions a.edit, .resource .actions a.add').live('click', function(event) {
    if(event.isPropagationStopped()) return; // wtf?

    event.preventDefault();
    event.stopPropagation();

    var resource = $(this).closest('.resource')[0];
    var match = resource.id.match(/(.*)_(\d+)/);

    if(match != null && match[2]) {
      var resource_name = match[1];
      var id = parseInt(match[2]);
      var method = 'put';
      var title = $('.name', $(resource)).html();
    } else {
      match = this.id.match(/new_(.*)/);
      var resource_name = match[1];
      var method = 'post';
      var title = 'New ' + resource_name;
    }

    var match = $('#sidebar form').attr('action').match(/^\/([a-zA-Z\-_]*)/);
    var path = '/' + match[1];
    if(id) path += '/' + id;

    $('#sidebar form').attr('action', path);
    $('#sidebar > h3').html(title);

    $('#sidebar form input[name=_method]').attr('value', method);
    var form_values = eval('(' + $(resource).attr('data-form-values') + ')');

    $.each(form_values, function(name, value) {
      if($.isArray(value)) {
        $('.' + resource_name + '_' + name).val(value);
      } else {
        if(typeof value == 'boolean') { // assume that true/false goes for checkboxes
          $('#' + resource_name + '_' + name).attr('checked', value);
        } else if(name == 'day' || name.match(/_date/)) {
          for(var i = 0; i < 3; i++) {
            $('#' + resource_name + '_' + name + '_' + (i + 1) + 'i').val(parseInt(value.split('-')[i], 10));
          }
        } else if(name.match(/_time/)) {
          for(var i = 0; i < 3; i++) {
            $('#' + resource_name + '_' + name + '_' + (i + 4) + 'i').val(value.split(':')[i]);
          }
        } else {
          $('#' + resource_name + '_' + name).val(value);
        }
      }
    });

    $('#sidebar form').trigger({
      type: 'on_' + resource_name + '_load',
      resource: $(resource)
    });
  });
});
$('.staff_requirement.new').live('click', function() {
  var element = $(this);
  var container = element.closest('.staff_requirement_container');
  container.find('ul').append('<li class="staff_requirement"></li>');
  var quantity = container.find('.required_quantity');
  quantity.val(parseInt(quantity.val()) + 1);
});

$('.staff_requirement:not(.new)').live('click', function() {
  var element = $(this);
  if(element.siblings('.staff_requirement:not(.new)').length < 1) return;
  var quantity = element.closest('.staff_requirement_container').find('.required_quantity');
  element.remove();
  quantity.val(parseInt(quantity.val()) - 1);
});
