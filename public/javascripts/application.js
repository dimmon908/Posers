function searchselect()
{
    a = ".t" + document.getElementById("searchbar1").value;  
    $(".sb").hide();
    $(a).show();
    if (document.getElementById("searchbar1").value == null)
    {
        document.getElementById("sbutton").enabled = false;
    }
}
function newselect()
{
    a = ".tn" + document.getElementById("newbar").value;
	b = ".sl" + document.getElementById("newbar").value;
    $(".sb2").hide();
    $(a).show();
	$(b).attr("disabled",""); 

    if (document.getElementById("newbar").value == '0')
    {
        document.getElementById("nbutton").disabled = true;
    }
    else
    {
        document.getElementById("nbutton").disabled = false;
    }
}

$(document).ready(function()
{
    $(".sb2").hide();
    if (document.getElementById("newbar") != undefined)
    {
        if (document.getElementById("newbar").value != '0')
        {
            a = ".tn" + document.getElementById("newbar").value;
			b = ".sl" + document.getElementById("newbar").value;

            $(a).show();
			$(b).attr("disabled",""); 

            document.getElementById("nbutton").disabled = false;
        }   
    } 
$(".a1").show();
	$(".hm1").mouseover (function () {
		 $(".bz").hide();
		 $(".a1").show();
	});
	$(".hm2").mouseover (function () {
		 $(".bz").hide();
		 $(".a2").show();
	});
	$(".hm3").mouseover (function () {
		 $(".bz").hide();
		 $(".a3").show();
	});
	$(".hm4").mouseover (function () {
		 $(".bz").hide();
		 $(".a4").show();
	});
});
function goThere(item)
{
	this.location.href = document.getElementById(item).options[document.getElementById(item).selectedIndex].value
}
function insertAtCaret(obj, text) {
	if(document.selection) {
		obj.focus();
		var orig = obj.value.replace(/\r\n/g, "\n");
		var range = document.selection.createRange();

		if(range.parentElement() != obj) {
			return false;
		}

		range.text = text;
		
		var actual = tmp = obj.value.replace(/\r\n/g, "\n");

		for(var diff = 0; diff < orig.length; diff++) {
			if(orig.charAt(diff) != actual.charAt(diff)) break;
		}

		for(var index = 0, start = 0; 
			tmp.match(text) 
				&& (tmp = tmp.replace(text, "")) 
				&& index <= diff; 
			index = start + text.length
		) {
			start = actual.indexOf(text, index);
		}
	} else if(obj.selectionStart) {
		var start = obj.selectionStart;
		var end   = obj.selectionEnd;

		obj.value = obj.value.substr(0, start) 
			+ text 
			+ obj.value.substr(end, obj.value.length);
	}
	
	if(start != null) {
		setCaretTo(obj, start + text.length);
	} else {
		obj.value += text;
	}
}

function setCaretTo(obj, pos) {
	if(obj.createTextRange) {
		var range = obj.createTextRange();
		range.move('character', pos);
		range.select();
	} else if(obj.selectionStart) {
		obj.focus();
		obj.setSelectionRange(pos, pos);
	}
}

var regExpCache = {};
function getClassRegExp(className)
{
	if (!(className in regExpCache))
		regExpCache[className] = new RegExp('(^|\\s)' + className + '(\\s|$)');

	return regExpCache[className];
}

function addLinkBehaviour(root)
{
	if (!root)
		root = document;

	var externalLinks = window.externalLinks == undefined ? 1 : window.externalLinks;

	var c = root.getElementsByTagName('a'), a, i = 0, attr, match;
	var external = getClassRegExp('external');
	var imageViewer = getClassRegExp('imageviewer(\\[(\\w+)\\])?');
	while ((a = c[i++]))
	{
		if ((attr = a.getAttribute('rel')))
		{
			if (externalLinks && (attr == 'external' || external.test(attr)))
				a.target = '_blank';
			if (window.ImageViewer && (attr == 'imageviewer' || (match = imageViewer.exec(attr))) && is.handheld == false)
				ImageViewer().addImage(
					attr == 'imageviewer' ? 'single' : match[3],
					{
						anchor: a,
						src: a.href,
						thumbsrc: first_child(a, 'img').src,
						caption: a.title
					}
				);
		}
	}

	return true;
}
