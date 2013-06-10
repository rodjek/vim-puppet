if exists("b:current_syntax")
    finish
endif

" node, class, defined type definition headers
syntax region  puppetDefine  start="^\s*\(class\|define\|node\)\s" end="{" contains=puppetDefType,puppetDefName,puppetDefArgs
syntax keyword puppetDefType class define node inherits contained
syntax match   puppetDefName "\v[a-z0-9\:]+" contained
syntax region  puppetDefArgs start="(" end=")" contains=@puppetArgs,puppetOperator contained

" include & require class
syntax match puppetInclude "\v\s*(include|require)\s+" nextgroup=puppetResName

" resource instances
syntax region  puppetResource start="^\s*[A-Za-z][a-z0-9_]*\(\:\:[A-Za-z][a-z0-9_]*\)*\s\+{" skip="\:\:" end="\:" contains=puppetResName,@puppetResTitle
syntax match   puppetResName  "[A-Za-z][a-z0-9_]*\(\:\:[A-Za-z][a-z0-9_]*\)*" contained
syntax cluster puppetResTitle contains=puppetString,puppetVariable,puppetArray
syntax region  puppetResAttr  start="\v\s*[a-z0-9_]+\s*\=\>" end="\(,\|;\|$\)" contains=puppetDefault,puppetResParam,puppetOperator,@puppetArgs
syntax match   puppetResParam "\v[a-z0-9_]+" contained

" resource refs
syntax match puppetRefType "\v(\:\:)?[A-Z][a-z0-9_]*(\:\:[A-Z][a-z0-9]+)*" contained nextgroup=@puppetArgs

" operators
syntax match puppetOperator "\v!" contained
syntax match puppetOperator "\v\*" contained
syntax match puppetOperator "\v/" contained 
syntax match puppetOperator "\v-" contained
syntax match puppetOperator "\v\+" contained
syntax match puppetOperator "\v\<\<" contained
syntax match puppetOperator "\v\>\>" contained
syntax match puppetOperator "\v\=" contained
syntax match puppetOperator "\v\=\=" contained
syntax match puppetOperator "\v!\=" contained
syntax match puppetOperator "\v\>\=" contained
syntax match puppetOperator "\v\<\=" contained
syntax match puppetOperator "\v\>" contained
syntax match puppetOperator "\v\<" contained
syntax match puppetOperator "\vand" contained
syntax match puppetOperator "\vor" contained

" keywords
syntax keyword puppetBoolean     true false contained
syntax keyword puppetDefault     default contained
syntax keyword puppetConditional if else elsif unless case

" Variables
syntax match  puppetVariable  "\v\$(\:\:)?[a-z0-9_]+(\:\:[a-z0-9_]+)*"
syntax region puppetVarAssign start="\v\$[a-z0-9_\:]+\s*\=" end="\($\|}\)" contains=puppetVariable,puppetOperator,@puppetArgs

" Comments
syntax match  puppetComment "\v#.*$"
syntax match  puppetComment "\v//.*$"
syntax region puppetComment start="\v/\*" end="\v\*/"

" Punctuation
syntax match puppetParen "\v\("
syntax match puppetParen "\v\)"
syntax match puppetBrace "\v\{"
syntax match puppetBrace "\v\}"
syntax match puppetComma "\v,"

" Functions
syntax region puppetFunction start="\w\+(" end=")" contains=puppetFuncName,@puppetArgs
syntax match  puppetFuncName "\v\w+" contained nextgroup=@puppetArgs

syntax cluster puppetArgs contains=puppetString,puppetFunction,puppetComma,puppetVariable,puppetBoolean,puppetArray,puppetRefType,puppetSelector

" Selectors
syntax region puppetSelector start="\v\?\s\{" end="\}" contained contains=@puppetArgs,puppetOperator,puppetDefault

" Strings
syntax region puppetString start=/\v"/ skip=/\v\\"/ end=/\v"/
syntax region puppetString start=/\v'/ skip=/\v\\'/ end=/\v'/
syntax region puppetString start=+\v/+ skip=+\v\\/+ end=+\v/+

" Array
syntax region puppetArray start="\v\[" end="\v\]" contained contains=@puppetArgs

highlight link puppetSelector    Delimiter

highlight link puppetArray       Delimiter
highlight link puppetRefType     Label
highlight link puppetComment     Comment
highlight link puppetString      String
highlight link puppetOperator    Operator
highlight link puppetFuncName    Function
highlight link puppetFunction    Delimiter
highlight link puppetParen       Delimiter
highlight link puppetBrace       Delimiter
highlight link puppetConditional Conditional
highlight link puppetDefType     Define
highlight link puppetDefName     Type
highlight link puppetDefine      Delimiter
highlight link puppetDefArgs     Delimiter
highlight link puppetVariable    Identifier
highlight link puppetBoolean     Boolean
highlight link puppetDefault     Label

highlight link puppetResource    Delimiter
highlight link puppetResName     Identifier
highlight link puppetResParam    Keyword

highlight link puppetInclude     Include

let b:current_syntax = "puppet"
