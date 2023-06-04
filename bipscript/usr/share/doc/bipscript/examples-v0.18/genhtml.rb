#!/usr/bin/ruby

require 'kramdown'
require 'pathname'
require 'fileutils'
require 'rexml/document'

def header f, title, level = 1
    path = "../" * level
    f.puts "<html><head>"
    f.puts "<title>Bipscript Example: #{title}</title>"
    f.puts "<link rel=\"stylesheet\" href=\"#{path}examples.css\" type=\"text/css\">"
    f.puts "<script type=\"text/javascript\" src=\"#{path}sh/shCore.js\"></script>"
    f.puts "<script type=\"text/javascript\" src=\"#{path}sh/shBrushJScript.js\"></script>"
    f.puts "<link href=\"#{path}sh/shCore.css\" rel=\"stylesheet\" type=\"text/css\"/>"
    f.puts "<link href=\"#{path}sh/shThemeDefault.css\" rel=\"stylesheet\" type=\"text/css\"/>"
    f.puts "</head><body><div id=\"pagecontainer\">\n"
end

def formatCode f, code, line
    code = code.gsub "\&", "&amp;"
    code = code.gsub "\<", "&lt;"
    code = code.gsub "\>", "&gt;"
    f.puts "<div class=\"bubbles\">"
    f.puts "<pre class=\"brush: js; first-line: #{line+1}\">\n"
    f.puts code + "\n</pre></div>"
end

def formatText f, text
    markdown = Kramdown::Document.new(text, :smart_quotes => ["apos", "apos", "quot", "quot"])
    f.puts markdown.to_html
end

def formatSound f, file
    f.puts "<audio controls>"
    f.puts "  <source src=\"#{file}\" type=\"audio/ogg\">"
    f.puts "</audio>"
end

def cclicense f, imgloc
    f.puts "<a rel=\"license\" href=\"http://creativecommons.org/licenses/by-nc-sa/4.0/\">"
    f.puts "<img alt=\"Creative Commons License\" style=\"float:right;border-width:0\" "
    f.puts "src=\"#{imgloc}/img/by-nc-sa.png\" /></a>"
    f.puts "<span class=\"fineprint\">This work is licensed under a <a rel=\"license\" "
    f.puts "href=\"http://creativecommons.org/licenses/by-nc-sa/4.0/\">"
    f.puts "Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.</span>"
end


def footer f
    # link
    f.puts "<div class=\"centertext\">"
    f.puts "<a href=\"../index.html\">List of All Examples</a>"
    f.puts "&bull;"
    f.puts "<a href=\"../demos.html\">Demo Applications</a></div><br/>\n"    # sh init
    f.puts "<hr/><script type=\"text/javascript\">"
    f.puts "SyntaxHighlighter.defaults['toolbar'] = false;"
    f.puts "SyntaxHighlighter.all()</script>"
    # cc license
    cclicense f, ".."
    # end tags
    f.puts "</div></body></html>"
end

def doFile file, out
    allCode = ""
    contents = file.read
    title = contents.match(/#\s*([^\n]+)/)[1]
    header out, title
    contents.split(/(\/\*\*[^\*]+\*\/)/).each do |tok|
        tok = tok.gsub(/\n\s*\/\/\s*vim:.*$/, "") # strip vim modeline
        if tok.start_with? "/**"
            formatText out, tok.match(/\/\*\*([^\*]+)\*\//)[1]
        elsif not tok.gsub(/\s+/, "").empty?
            if tok =~ /\$audio\s+([^\s]+)\s/
                formatSound out, $1
            else
                formatCode out, tok, allCode.count("\n")
                allCode += tok.rstrip.sub(/$\n*/,"") + "\n\n"
            end
        end
    end
    formatText out, "<br/>\n<hr/>\n##Complete Script"
    formatCode out, allCode, 0
    footer out
end

def doIndex file, out
  header out, "Index", 0
  xmldoc = REXML::Document.new(file)
  out.puts "<h1>Bipscript Examples</h1>"
  out.puts "<table class=\"toc\">"
  xmldoc.elements.each("root/example") do |e|
    out.puts "<tr><td>"
    out.puts "<a href=\"#{e.attributes["tag"]}/#{e.attributes["tag"]}.html\">"
    out.puts "#{e.attributes["name"]}</a></td>"
    out.puts "<td>#{e.text}</td></tr>"
  end
  out.puts "</table>"
  out.puts "<hr/>"
  cclicense out, "."
  # end tags
  out.puts "</div></body></html>"
end

def doDemos file, out
  header out, "Index", 0
  xmldoc = REXML::Document.new(file)
  out.puts "<h1>Bipscript Demo Applications</h1>"
  xmldoc.elements.each("root/demo") do |e|
    out.puts "<div class='bubbles'>"
    out.puts "<h2>#{e.attributes['name']}</h2>"
    formatText out, e.text
    out.puts "</div>"
  end
  out.puts "<hr/>"
  cclicense out, "."
  # end tags
  out.puts "</div></body></html>"
end

indir = "./src/"
inpath = Pathname.new indir
outdir = "./html/"
outpath = Pathname.new outdir

Dir.glob(indir + "/*").each do|f|
    if File.directory? f
        Dir.glob(f + "/*.bip").each do |file|
            # filename without .bip extension
            basefile = File.basename(file, ".bip")
            # add parent folder
            basepath = Pathname.new(f + '/' + basefile)
            # find relative to input base
            relpath = basepath.relative_path_from inpath
            # output relative to output base
            outfile = (outpath + relpath).to_s + ".html"
            # create folder
            dir = File.dirname(outfile)
            Dir.mkdir(dir) unless File.exists?(dir)
            # run generation
            doFile File.open(file), File.open(outfile, 'w')
        end
    end
end

# generate index
doIndex File.open(indir + "index.xml"), File.open(outpath + "index.html", 'w')

# generate demos index
doDemos File.open(indir + "demos.xml"), File.open(outpath + "demos.html", 'w')

# copy SH library
FileUtils.cp_r "./sh", "./html"
# copy css
FileUtils.cp "examples.css", "./html"
# copy images
FileUtils.cp_r "./img", "./html"
