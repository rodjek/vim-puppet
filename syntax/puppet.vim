" puppet syntax file
" Filename:     puppet.vim
" Language:     puppet configuration file
" Maintainer:   Luke Kanies <luke@madstop.com>
" URL:
" Last Change:
" Version:
"

" Copied from the cfengine, ruby, and perl syntax files
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match    puppetBraces "{}"       contained transparent
syn match    puppetParens "()"       contained transparent

" match class/definition/node declarations/application
syn region   puppetDefine            start="\(\<class\>\|\<define\>\|\<application\>\)\s\{-}[a-z0-9_-]\+\(::[A-Za-z0-9_-]\+\)*" end="{"me=s-1 nextgroup=puppetDefineContent contains=puppetDefType,puppetDefArguments,puppetClassInherit
syn match    puppetDefType           "\(\<class\>\|\<define\>\|\<node\>\|\<application\>\)" contained
syn region   puppetDefArguments      matchgroup=puppetParens start="("	end=")"		   nextgroup=puppetClassInherit,puppetDefineContent contained contains=TOP skipwhite skipempty
syn match    puppetClassInherit      "inherits\s.*{"me=e-1 contains=puppetKeyword contained
syn region   puppetDefineContent     matchgroup=puppetBraces start="{"	end="}"		   contained contains=TOP fold
syn keyword  puppetDataTypes         String Integer Float Numeric Boolean Array Hash Regexp Undef Default Resource Class Scalar Collection Variant Data Pattern Enum Tuple Struct Optional Catalogentry Type Any Callable
syn keyword  puppetParamKeyword      present absent purged latest installed running stopped mounted unmounted role configured file directory link on_failure contained

syn cluster  puppetNotTop            contains=puppetVariable,puppetString,puppetParamKeyword,puppetSpecial,puppetBoolean,puppetControl,puppetDefType

syn region   puppetNode              start="\<node\>" end="{"me=s-1 contains=puppetDefType,puppetRegex,puppetString nextgroup=puppetNodeContent skipwhite skipempty extend
syn region   puppetNodeContent	     matchgroup=puppetBraces start=/{/	end=/}/ contains=ALLBUT,puppetNode transparent fold contained keepend

syn match    puppetResource	         "^@\?@\?[a-z0-9_-]\+\(::[A-Za-z0-9_-]\+\)*\s\{-}{"me=e-1	    nextgroup=puppetResourceContent contains=ALLBUT,@puppetNotTop,puppetNode
syn match    puppetResource	         "\s@\?@\?[a-z0-9_-]\+\(::[A-Za-z0-9_-]\+\)*\s\{-}{"me=e-1	  nextgroup=puppetResourceContent contains=ALLBUT,@puppetNotTop,puppetNode
syn match    puppetResource	         "@\?@\?[A-Z][a-z0-9_-]\+\(::[A-Za-z0-9_-]\+\)*\s\{-}{"me=e-1	nextgroup=puppetResourceContent
syn match    puppetResource	         "[A-Z][a-z0-9_-]\+\(::[A-Za-z0-9_-]\+\)*\s\{-}\["me=e-1	    nextgroup=puppetResourceContent
syn match    puppetResource	         "[A-Z][a-z0-9_-]\+\(::[A-Za-z0-9_-]\+\)*\s\{-}<<|"me=e-3	    nextgroup=puppetResourceContent
syn match    puppetResource	         "[A-Z][a-z0-9_-]\+\(::[A-Za-z0-9_-]\+\)*\s\{-}<|"me=e-2	    nextgroup=puppetResourceContent
syn region   puppetResourceContent	 matchgroup=puppetBraces start="{"	end="}"		contained contains=ALLBUT,puppetNode extend fold skipwhite skipempty
syn region   puppetControls          matchgroup=puppetControl start="\(\<if\>\|\<case\>\|\<elseif\>\)" end="{"me=s-1 contains=puppetDefArguments,puppetClassInherit,puppetControl skipwhite skipempty extend fold

syn match    puppetFunctionName      "[A-Za-z0-9_-]*("me=e-1	  nextgroup=puppetFunctionParams skipwhite
syn match    puppetFunctionName      "[A-Za-z0-9_-]*\s*("me=e-1	nextgroup=puppetFunctionParams skipwhite
syn region   puppetFunctionParams    matchgroup=puppetParens start="("lc=-1	end=")"lc=-1		   contained skipwhite contains=ALL

syn match    puppetParamDigits       "[0-9]\+"

syn match    puppetParamName         "\w\+\s*[=+]>"me=e-2 contains=puppetParamName
syn match    puppetVariable          "${\?\(::\)\?[a-z][a-zA-Z0-9_]*\(::[a-z][a-zA-Z0-9_]*\)*}\?" contains=@NoSpell
syn match    puppetParen             "("
syn match    puppetParen             ")"
syn match    puppetBrace             "{"
syn match    puppetBrace             "}"
syn match    puppetBrack             "\["
syn match    puppetBrack             "\]"
syn match    puppetBrack             "<|"
syn match    puppetBrack             "|>"
syn match    puppetBrack             "<<|"
syn match    puppetBrack             "|>>"

" match anything between simple/double quotes.
" don't match variables if preceded by a backslash.
syn region   puppetString            start=+'+ skip=+\\\\\|\\'+ end=+'+
syn region   puppetString            start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=puppetVariable,puppetNotVariable
syn match    puppetNotVariable       "\\$\w\+" contained
syn match    puppetNotVariable       "\\${\w\+}" contained

syn keyword  puppetKeyword           import inherits include require contain produces
syn keyword  puppetControl           case default if else elsif unless
syn keyword  puppetSpecial           undef
syn keyword  puppetOperator          and or in
syn keyword  puppetBoolean           true false

" Match the Regular Expression type
" XXX: Puppet does not currently support a few features available in the
" full Ruby Regexp class, namely, interpolation, lookbehind and named
" sub-expressions.  Matches for these features are included in the
" commented-out versions of puppetRegexParen and puppetRegexSubName,
" plus the supporting groups puppetRegexAngBrack and puppetRegexTick.
syn region   puppetRegex             start="/" skip="\\/" end="/" contains=puppetRegexParen,puppetRegexBrace,puppetRegexOrpuppetRegexBrack,puppetRegexComment
""syn match   puppetRegexParen       "(\(?\([imx]\{0,4}:\|[=!]\)\)\?" contains=puppetRegexSpecChar,puppetRegexSubName contained
"syn match   puppetRegexParen       "(\(?\([imxo]\{0,4}:\|['<][[:alnum:]]\+[>']\|<?[=!]\)\)\?" contains=puppetRegexSpecChar,puppetRegexSubName contained
"syn match   puppetRegexParen       ")" contained
""syn match   puppetRegexBrace       "{" contained
""syn match   puppetRegexBrace       "}" contained
""syn match   puppetRegexBrack       "\[" contained
""syn match   puppetRegexBrack       "\]" contained
"syn match   puppetRegexAngBrack    "<" contained
"syn match   puppetRegexAngBrack    ">" contained
"syn match   puppetRegexTick        +'+ contained
""syn match   puppetRegexOr          "|" contained
"syn match   puppetRegexSubName     "['<][[:alnum:]]\+[>']" contains=puppetRegexAngBrack,puppetRegexTick contained
"syn match   puppetRegexSpecialChar "[?:imx]\|\(<?[=!]\)" contained
""syn region  puppetRegexComment     start="(?#" skip="\\)" end=")" contained

" comments last overriding everything else
syn match    puppetComment           "\s*#.*$" contains=puppetTodo,@Spell
syn region   puppetMultilineComment  start="/\*" end="\*/" contains=puppetTodo,@Spell
syn keyword  puppetTodo              TODO NOTE FIXME XXX BUG HACK contained
syn keyword  puppetTodo              TODO: NOTE: FIXME: XXX: BUG: HACK: contained



" Relationship
syn match   puppetRelationship       "\(\~>\|->\|<\~\|<-\)"
syn sync    fromstart

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_puppet_syn_inits")
  if version < 508
    let did_puppet_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink puppetVariable             Identifier
  HiLink puppetType                 Identifier
  HiLink puppetKeyword              Keyword
  HiLink puppetComment              Comment
  HiLink puppetMultilineComment     Comment
  HiLink puppetString               String
  HiLink puppetRelationship         Keyword
  HiLink puppetRegex                Constant
  HiLink puppetRegexParen           Delimiter
  HiLink puppetRegexBrace           Delimiter
  HiLink puppetRegexBrack           Delimiter
  HiLink puppetRegexAngBrack        Delimiter
  HiLink puppetRegexTick            Delimiter
  HiLink puppetRegexOr              Delimiter
  HiLink puppetRegexSubName         Identifier
  HiLink puppetRegexSpecChar        SpecialChar
  HiLink puppetRegexComment         Comment
  HiLink puppetParamKeyword         Keyword
  HiLink puppetParamDigits          Constant
  HiLink puppetBoolean              Boolean
  HiLink puppetOperator             Special
  HiLink puppetSpecial              Special
  HiLink puppetTodo                 Todo
  HiLink puppetBraces               Delimiter
  HiLink puppetParens               Delimiter
  HiLink puppetColon                Delimiter
  HiLink puppetBrack                Delimiter
  HiLink puppetTypeBrack            Delimiter
  HiLink puppetBrace                Delimiter
  HiLink puppetTypeBrace            Delimiter
  HiLink puppetParen                Delimiter
  HiLink puppetDelimiter            Delimiter
  HiLink puppetControl              Statement
  HiLink puppetDefType              Statement
  HiLink puppetDefine               Define
  HiLink puppetDataTypes            Define
  HiLink puppetDefName              Type
  HiLink puppetNodeRe               Type
  HiLink puppetTypeName             Statement
  HiLink puppetTypeDefault          Type
  HiLink puppetParamName            Identifier
  HiLink puppetArgument             Identifier
  HiLink puppetInstance             Define
  HiLink puppetResType              Define
  HiLink puppetArgFunction          Function
  HiLink puppetClassInherit         Type
  HiLink puppetFunctionName         Type
  HiLink puppetDefineName           Define
  HiLink puppetResource             Define
  HiLink puppetNodeContent          Special

  delcommand HiLink
endif

let b:current_syntax = "puppet"
