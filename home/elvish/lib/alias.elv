use re
use str

var dir = $E:XDG_CONFIG_HOME/elvish/aliases

var arg-replacer = '{}'

var aliases = [&]

fn -define-alias {|name body|
  eval $body
  set aliases[$name] = $body
}

fn -load-alias {|name file|
  var body = (slurp < $file)
  -define-alias $name $body
}

fn -save {|&verbose=$false name|
  if (has-key $aliases $name) {
    var tmp-file = (mktemp $dir/tmp.XXXXXXXXXX)
    var file = $dir/$name.elv
    echo $aliases[$name] > $tmp-file
    e:mv $tmp-file $file
    if $verbose {
      echo (styled "Alias "$name" saved to "$file"." green)
    }
  } else {
    echo (styled "Alias "$name" is not defined." red)
  }
}

fn save {|&verbose=$false &all=$false @names|
  if $all {
    set names = [(keys $aliases)]
  }
  each {|n|
    -save &verbose=$verbose $n
  } $names
}

fn def {|&verbose=$false &save=$false &use=[] name @cmd|
  var use-statements = [(each {|m| put "use "$m";" } $use)]
  var args-at-end = '$@_args'
  var new-cmd = [
    (each {|e|
        if (eq $e $arg-replacer) {
          print '$@_args '
          set args-at-end = ''
        } else {
          print $e' '
        }
    } $cmd)
  ]
  var body = ({
    echo "#alias:new" $name (if (not-eq $use []) { put "&use="(to-string $use) }) (each {|w| repr $w } $cmd)
    print "edit:add-var "$name'~ {|@_args| ' $@use-statements $@new-cmd $args-at-end '}'
  } | slurp)
  -define-alias $name $body
  if $save {
    save $name
  }
  if $verbose {
    echo (styled "Alias "$name" defined"(if $save { echo " and saved" } else { echo "" })"." green)
  }
}

var new~ = $def~

fn bash-alias {|@args|
  var line = $@args
  var name cmd = (str:split &max=2 '=' $line)
  def $name $cmd
}

fn list {
  keys $aliases | each {|n|
    echo (re:find '^#(alias:new .*)\n' $aliases[$n])[groups][1][text]
  }
}

var ls~ = $list~ # ls is an alias for list

fn undef {|name|
  if (has-key $aliases $name) {
    var file = $dir/$name.elv
    e:rm -f $file
    del aliases[$name]
    edit:add-var $name"~" (external $name)
    echo (styled "Alias "$name" removed." green)
  } else {
    echo (styled "Alias "$name" does not exist." red)
  }
}

var rm~ = $undef~ # rm is an alias for undef

fn init {
  if (not ?(test -d $dir)) {
    mkdir -p $dir
  }

  for file [(set _ = ?(put $dir/*.elv))] {
    var content = (cat $file | slurp)
    if (re:match '^#alias:new ' $content) {
      var name cmd = (re:find '^#alias:new (\S+)\s+(.*)\n' $content)[groups][1 2][text]
      def $name (edit:wordify $cmd)
    }
  }
}

init
