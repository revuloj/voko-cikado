
$(document).ready(function () {
    $("#s_klasikaj").click("klasikaj",citaĵoSerĉo);
    $("#s_postaj").click("postaj",citaĵoSerĉo);
});

jQuery.extend({

   alportu: function(url,params,error_to) {
      $(error_to).hide();
      $("body").css("cursor", "progress");
  
      return (
          this.post(url,params)
          .fail (
            function(xhr) {
                console.error(xhr.status + " " + xhr.statusText);
                if (error_to) {
                    var msg = "Pardonu, okazis netandita eraro: ";
                        $(error_to).html( msg + xhr.status + " " + xhr.statusText + xhr.responseText);
                        $(error_to).show()  
                }
            })
          .always(
            function() {
                $("body").css("cursor", "default");
            })
        )
    },

});


/*** XMLŜablono: baza funkcioj de ŝablonoj ***/
var XMLŜablono = function(sxablono) {
    this.sxablono = sxablono;
}

XMLŜablono.prototype = {

    xml: function(args,indent=0) {
        // args: Objekto kiu enhavas la anstataŭigendajn valorojn,  kiuj aperas kiel {...} 
        // en la ŝablono, ekz {rad: "hom", fin: "o",...}
        var sx = this.sxablono.split("\n");
        var resultstr = '', ispaces='';
        for (var i=0; i<sx.length; i++) {
            var line = sx[i];
            var pos = line.indexOf(":");
            if (pos >= 0) {
                var cond = line.slice(0,pos);
                var str = line.slice(pos+1);
            } else {
                cond = '';
                str = line;
            }
            if (this.eval_condition(cond,args)) 
                    resultstr += this.eval_varstring(str,args) + "\n";
            
        }
        if (indent) {
            // var ispaces = new Array(indent+1).join(" ");
            ispaces = ' '.repeat(indent);
            resultstr = ispaces + (resultstr.replace(/\n/g,'\n'+ispaces)).trim();
        }
        return resultstr;   
    },

    eval_condition: function(cond,args) {
        var c = cond.trim();
        return c? new Function("return " + c.replace(/(\w+)/g,"this.$1")).call(args) : true;
    },
                
    eval_varstring: function(str,args) {
        return str.replace(/\{([a-z_]+)\}/g, function(_m,$1){ return args[$1]} );
    }
}

/*** HTMLFonto: krei novan fonton (ekz. en trov-listo) surbaze de ŝablono ***/

var HTMLFonto = function(bib_src) {
    this.source = bib_src;
    this.v = new XMLŜablono(html_sxablonoj.vrk);
    this.b = new XMLŜablono(html_sxablonoj.bib);
    this.vt = new XMLŜablono(html_sxablonoj.vrk_title);
    this.bt = new XMLŜablono(html_sxablonoj.bib_title);
}

HTMLFonto.prototype = {
    bib_text: function(bib) {
        for (var i=0;i<this.source.length;i++) {
            entry = this.source[i];
            if (entry.value == bib) {
                return entry.label
            }
        }
    },
    
    html: function(fnt) {
        var _html = '', f = {};
        var bib = fnt.bib;

        var f = {
           vrk: this.v.xml(fnt).trim(),
           bib: this.b.xml(fnt).trim(),
           aut: fnt.aut,
           lok: fnt.lok
        }
    
        f.vrk = this.vt.xml(f).trim();
        if (bib) {
            f.bib_text =  this.bib_text(bib);
            _html = this.bt.xml(f).trim();
        } else {
            _html = f.vrk;
        }

        return _html;
    }
}

/*** HTMLTrovoDt, HTMLTrovoDdBld: krei novan trovon (ekz. en trov-listo) surbaze de ŝablono ***/

var HTMLTrovoDt = function() {
    this.t = new XMLŜablono(html_sxablonoj.dt_trovo);
    this.tc = new XMLŜablono(html_sxablonoj.dt_trovo_cit);
}

HTMLTrovoDt.prototype = {
    html: function(trv) {
        if (trv.title.includes(trv.url)) {
            return this.tc.xml(trv).trim();
        } else {
            return this.t.xml(trv).trim();
        }
    }
}


var html_sxablonoj = {
    vrk:
    'vrk && url : <a href="{url}" target="_new">{vrk}</a>\n' +
    'vrk && !url: {vrk}\n',
    
    bib:
    'bib && url : <a href="{url}" target="_new">{bib}</a>\n' +
    'bib && !url: {bib}\n',
  
    vrk_title:
    'aut        : {aut}:\n' +
    'vrk && lok : {vrk},\n' +
    'vrk && !lok: {vrk}\n' +
    'lok        : {lok}\n',
  
    bib_title:
    'bib && vrk : {bib}, {vrk}\n' +
    'bib && !vrk : {bib}, {bib_text}\n',
  
    dt_trovo:
    '       :<dt>{prompt} <span class="trovo_titolo">\n' +
    'url    :  <a href="{url}" target="_new" >{title}</a>\n' +
    '!url   :  {title}\n' +
    '       :  </span>\n' +
    '       :  <button id="r_{id}"/>\n' +
    'enm_btn:  <button id="e_{id}"/>\n' +
    '       :</dt>\n',
  
    dt_trovo_cit:
    '       :<dt>{prompt} <span class="trovo_titolo">\n' +
    '       :  {title}\n' +
    '       :  </span>\n' +
    '       :  <button id="r_{id}"/>\n' +
    'enm_btn:  <button id="e_{id}"/>\n' +
    '       :</dt>\n',
  
  }



function _serĉo_preparo() {
    //if (! $("#sercho_sercho").validate()) return;

    $("#sercho_trovoj").html('');
    $("#sercho_trovoj button").off("click");

    return true;
}


function _bib_url(source,bib) {
    for (var i=0;i<source.length;i++) {
        entry = source[i];
        if (entry.value == bib) {
            return entry.url
        }
    }
}

function citaĵoSerĉo(event) {
    event.preventDefault();

    if (! _serĉo_preparo()) return;

    $.alportu(
        '../cikado',
        { 
            sercho: $("#sercho_sercho").val(),
            kie: event.data
        }, 
        '#sercho_error')
    .done(
        function(data) {   
            var bib_src = $( "#ekzemplo_bib" ).autocomplete( "option", "source" );
            var htmlFnt = new HTMLFonto(bib_src);
            var ŝablono = new HTMLTrovoDt();

            if (data.length && data[0].cit) {
                for (var i=0; i<data.length; i++) {
                    var trovo = data[i], fnt = trovo.cit.fnt;
                    let url = ( fnt.url ? fnt.url : ( fnt.bib ? _bib_url(bib_src,fnt.bib) : '') );
                    var perc = make_percent_bar(trovo.sim*100, bar_styles[12], 20, 20);
                    $("#sercho_trovoj").append('<dd id="trv_' + i + '">');
                    $("#trv_"  + i).Trovo(
                        {
                            ŝablono: ŝablono,
                            valoroj: {
                                prompt: '&nbsp;&nbsp;<span class="perc_bar">' + perc.str + '</span>&nbsp;&nbsp;',
                                url: url,
                                title: '(' + (i+1) + ') ' + htmlFnt.html(fnt),
                                descr: trovo.cit.ekz,
                                data: trovo
                            }
                        },
                    );

                    // sercho_rigardu_btn_reaction(i,url);
                    // sercho_enmetu_btn_reaction(i,trovo);
                }
            } else {
                    $("#sercho_trovoj")
                        .append("<p>&nbsp;&nbsp;Neniuj trovoj.</p>");
            }
        }
    )
}


$.widget( "redaktilo.Trovo", {
    options: {
        type: "teksto",
        ŝablono: new HTMLTrovoDt(),
        bld_ŝablonono: null,
        valoroj: {
            prompt: "&nbsp;&nbsp;&#x25B6;&#xFE0E;",
            url: null,
            title: '',
            descr: '',
            data: {},
            enm_btn: true
        }
    },

    _create: function() {
        this._super();

        var o = this.options;
        var v = o.valoroj
        v.id = this.element.attr("id");
        var htmlstr = o.ŝablono.html(v);
        /*
            '<dt>' + o.prompt + ' ' + '<span class = "trovo_titolo">'
                +  ( o.url ? 
                        '<a href="' + o.url + '" target="_new" ' + '>' + o.title + '</a>'
                        : o.title 
                    )
                + '</span> '
                + '<button id="r_' + id + '"/> '
                + ( o.enm_btn ? '<button id="e_' + id + '"/> ' : '' )
            + '</dt>\n';
            */
        this.element.before(htmlstr);
        if (v.descr) this.element.text(v.descr);

        if (o.type == "teksto") {
            $("#r_" + v.id).RigardoBtn({url: v.url});
        }
    }
});


$.widget( "redaktilo.RigardoBtn", {
    options: {
        url: null
    },

    _create: function() {
        this._super();

        var e = this.element;
        e.attr("style","visibility: hidden");
        e.attr("type","button");
        e.attr("title","sur aparta paĝo");
        e.html("Rigardu");

        this._on({
            click: function(event) {
                if (this.options.url) {
                    event.preventDefault();
                    window.open(this.options.url);
                    //console.debug("malfermas: "+url);
                } else {
                    throw nedifinita_url;
                }
            }
        })
    }
});


/*************************************************************************

// procento-traboj: (c) Changaco, https://github.com/Changaco/unicode-progress-bars
// adaptita de Wolfram Diestel

// cetero: (c) 2016 - 2018 Wolfram Diestel
// laŭ GPL 2.0

*****************************************************************************/


var bar_styles = [
    '▁▂▃▄▅▆▇█',
    '⣀⣄⣤⣦⣶⣷⣿',
    '⣀⣄⣆⣇⣧⣷⣿',
    '○◔◐◕⬤',
    '□◱◧▣■',
    '□◱▨▩■',
    '□◱▥▦■',
    '░▒▓█',
    '░█',
    '⬜⬛',
    '▱▰',
    '▭◼',
    '▯▮',
    '◯⬤',
    '⚪⚫',
];

function repeat(s, i) {
    var r = '';
    for(var j=0; j<i; j++) r += s;
    return r;
}

function make_percent_bar(p, bar_style, min_size, max_size) {
    var d, full, m, middle, r, rest, x,
        min_delta = Number.POSITIVE_INFINITY,
        full_symbol = bar_style[bar_style.length-1],
        n = bar_style.length - 1;
    if(p == 100) return {str: repeat(full_symbol, max_size), delta: 0};
    p = p / 100;
    for(var i=max_size; i>=min_size; i--) {
        x = p * i;
        full = Math.floor(x);
        rest = x - full;
        middle = Math.floor(rest * n);
        if(p != 0 && full == 0 && middle == 0) middle = 1;
        d = Math.abs(p - (full+middle/n)/i) * 100;
        if(d < min_delta) {
            min_delta = d;
            m = bar_style[middle];
            if(full == i) m = '';
            r = repeat(full_symbol, full) + m + repeat(bar_style[0], i-full-1);
        }
    }
    return {str: r, delta: min_delta};
}