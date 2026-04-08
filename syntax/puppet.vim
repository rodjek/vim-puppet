" Language:     Puppet
" Maintainer:   Voxpupuli
" URL:          https://github.com/voxpupuli/vim-puppet
"
" Thanks to Doug Kearns who maintains the vim syntax file for Ruby. Many constructs, including interpolation
" and heredoc was copied from ruby and then modified to comply with Puppet syntax.

" Prelude {{{1
if exists('b:current_syntax')
  finish
endif

" this file uses line continuations
let s:cpo_sav = &cpo
set cpo&vim

if !exists('g:puppet_display_errors')
  let g:puppet_display_errors = 1
endif

syn cluster puppetNotTop contains=@puppetExtendedStringSpecial,@puppetRegexpSpecial,puppetTodo

syn match puppetSpaceError display excludenl "\s\+$"
syn match puppetSpaceError display " \+\t\+\%( \|\t\)*\|\t\+ \+\%( \|\t\)*"

" one character operators
syn match  puppetOperator "[=><+/*%!.|@:,;?~-]"

" two character operators
syn match  puppetOperator "+=\|-=\|==\|!=\|=\~\|!\~\|>=\|<=\|<-\|<\~\|=>\|+>\|->\|\~>\|<<\||>\|@@"

" three character operators
syn match  puppetOperator "<<|\||>>"

syn region puppetBracketBlock transparent matchgroup=puppetBracket start="\[" end="]" fold contains=ALLBUT,@puppetNotTop
syn region puppetBraceBlock transparent matchgroup=puppetBrace start="{" end="}" fold contains=ALLBUT,@puppetNotTop
syn region puppetParenBlock transparent matchgroup=puppetParen start="(" end=")" fold contains=ALLBUT,@puppetNotTop

" Expression Substitution and Backslash Notation {{{1
syn match puppetStringEscape "\\\\\|\\[abefnrstv]\|\\\o\{1,3}\|\\x\x\{1,2}" contained display
syn match puppetStringEscape "\%(\\M-\\C-\|\\C-\\M-\|\\M-\\c\|\\c\\M-\|\\c\|\\C-\|\\M-\)\%(\\\o\{1,3}\|\\x\x\{1,2}\|\\\=\S\)" contained display
syn match puppetQuoteEscape  "\\[\\']" contained display

syn region puppetNoInterpolation contained transparent start="\\${" end="}"
syn match  puppetNoInterpolation display contained "\\${"
syn match  puppetNoInterpolation display contained "\\$\w\+"
syn region puppetInterpolation transparent matchgroup=puppetInterpolationDelimiter start="${" end="}" contained contains=ALLBUT,@puppetNotTop
syn match  puppetInterpolation "$\%(::\)\?\w\+"                        display contained contains=puppetInterpolationDelimiter,puppetVariable
syn match  puppetInterpolation "$\$\%(-\w\|\W\)"              display contained contains=puppetInterpolationDelimiter,puppetVariable
syn match  puppetInterpolationDelimiter "$\ze\$\w\+"            display contained
syn match  puppetInterpolationDelimiter "$\ze\$\%(-\w\|\W\)"    display contained

syn match puppetDelimiterEscape	"\\[(<{\[)>}\]]" transparent display contained contains=NONE

syn region puppetNestedParentheses    start="("  skip="\\\\\|\\)"  matchgroup=puppetString end=")"	transparent contained
syn region puppetNestedCurlyBraces    start="{"  skip="\\\\\|\\}"  matchgroup=puppetString end="}"	transparent contained
syn region puppetNestedAngleBrackets  start="<"  skip="\\\\\|\\>"  matchgroup=puppetString end=">"	transparent contained
syn region puppetNestedSquareBrackets start="\[" skip="\\\\\|\\\]" matchgroup=puppetString end="\]"	transparent contained

" Regular Expression Metacharacters {{{1
" These are mostly Oniguruma ready
syn region puppetRegexpComment	matchgroup=puppetRegexpSpecial   start="(?#"	skip="\\)"  end=")"  contained
syn region puppetRegexpParens	matchgroup=puppetRegexpSpecial   start="(\(?:\|?<\=[=!]\|?>\|?<[a-z_]\w*>\|?[imx]*-[imx]*:\=\|\%(?#\)\@!\)" skip="\\)"  end=")"  contained transparent contains=@puppetRegexpSpecial
syn region puppetRegexpBrackets	matchgroup=puppetRegexpCharClass start="\[\^\=" skip="\\\]" end="\]" contained transparent contains=puppetStringEscape,puppetRegexpEscape,puppetRegexpCharClass oneline
syn match  puppetRegexpCharClass	"\\[DdHhSsWw]"	       contained display
syn match  puppetRegexpCharClass	"\[:\^\=\%(alnum\|alpha\|ascii\|blank\|cntrl\|digit\|graph\|lower\|print\|punct\|space\|upper\|xdigit\):\]" contained
syn match  puppetRegexpEscape	"\\[].*?+^$|\\/(){}[]" contained
syn match  puppetRegexpQuantifier	"[*?+][?+]\="	       contained display
syn match  puppetRegexpQuantifier	"{\d\+\%(,\d*\)\=}?\=" contained display
syn match  puppetRegexpAnchor	"[$^]\|\\[ABbGZz]"     contained display
syn match  puppetRegexpDot	"\."		       contained display
syn match  puppetRegexpSpecial	"|"		       contained display
syn match  puppetRegexpSpecial	"\\[1-9]\d\=\d\@!"     contained display
syn match  puppetRegexpSpecial	"\\k<\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\=>" contained display
syn match  puppetRegexpSpecial	"\\k'\%([a-z_]\w*\|-\=\d\+\)\%([+-]\d\+\)\='" contained display
syn match  puppetRegexpSpecial	"\\g<\%([a-z_]\w*\|-\=\d\+\)>" contained display
syn match  puppetRegexpSpecial	"\\g'\%([a-z_]\w*\|-\=\d\+\)'" contained display

syn cluster puppetStringSpecial	      contains=puppetInterpolation,puppetNoInterpolation,puppetStringEscape
syn cluster puppetExtendedStringSpecial contains=@puppetStringSpecial,puppetNestedParentheses,puppetNestedCurlyBraces,puppetNestedAngleBrackets,puppetNestedSquareBrackets
syn cluster puppetRegexpSpecial	      contains=puppetRegexpSpecial,puppetRegexpEscape,puppetRegexpBrackets,puppetRegexpCharClass,puppetRegexpDot,puppetRegexpQuantifier,puppetRegexpAnchor,puppetRegexpParens,puppetRegexpComment

syn match puppetInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+r\=i\=\>" display
syn match puppetInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)r\=i\=\>" display
syn match puppetInteger	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0\o\+r\=i\=\>" display
syn match puppetFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)\.\d\+r\=i\=\>" display
syn match puppetFloat	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=[eE][-+]\=\d\+r\=i\=\>" display
" order of matches is important. The following need to be placed after the ones above
syn match puppetInvalidNumber	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\%(\|\<0\d\+\)\.\d\+\>" display
syn match puppetInvalidNumber	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0[xX]\x\+\.\x\+\>" display
syn match puppetInvalidNumber	"\%(\%(\w\|[]})\"']\s*\)\@<!-\)\=\<0\o*[89]\d*\>" display

syn match puppetVariable "$\%(::\)\=\w\+\%(::\w\+\)*" display
" resource or function name
syn match puppetName "\%(\%(::\)\=\|\<\)[a-z]\w*\%(::[a-z]\w*\)*\>" display
" resource reference or data type
syn match puppetType "\%(\%(::\)\=\|\<\)[A-Z]\w*\%(::[A-Z]\w*\)*\>" display
" See https://www.puppet.com/docs/puppet/8/lang_data_string#lang_data_string_bare_words
syn match puppetBareWordString "\%(\%(\%(::\)\=\|\<\)\%(_[\w-]*\w\+\)\|\%([a-z]\%(\w*-\)\+\w\+\)\)\+\>" display
" bad name containing combinations of segment starting with lower case and segement starting with upper case (or vice versa)
syn match puppetInvalidName "\%(\%(::\)\=\|\<\)\%(\w\+::\)*\%(\%([a-z]\w*::[A-Z]\w*\)\|\%([A-Z]\w*::[a-z]\w*\)\)\%(::\w\+\)*\>" display
syn cluster puppetNameOrType contains=puppetVariable,puppetName,puppetType,puppetBareWordString,puppetInvalidName

syn keyword puppetControl  case in
syn keyword puppetStructure node class define plan
syn keyword puppetKeyword  inherits function type attr private
syn keyword puppetKeyword  application consumes produces site component environment unit
syn keyword puppetKeyword  present absent purged latest installed running stopped mounted unmounted role configured
syn keyword puppetKeyword  directory link on_failure regexp
syn keyword puppetConstant default undef
syn keyword puppetConditional if else elsif unless and or
syn keyword puppetBoolean  true false

" Core functions that include more code
syn keyword puppetIncludeFunction contain create_resources include hiera_include require

" Core functions
syn keyword puppetConditional then lest
syn keyword puppetRepeat break each map next return reverse_each
syn keyword puppetDebug alert crit debug emerg err fail info notice warning
syn keyword puppetFunction abs all annotate any assert_type binary_file call camelcase capitalize ceiling chomp chop
syn keyword puppetFunction compare convert_to defined dig digest downcase empty epp eyaml_lookup_key file filter
syn keyword puppetFunction find_file find_template flatten floor fqdn_rand generate get getvar group_by hiera
syn keyword puppetFunction hiera_array hiera_hash hocon_data index inline_epp inline_template join json_data keys
syn keyword puppetFunction length lookup lstrip match max md5 min module_directory new partition realize reduce
syn keyword puppetFunction regsubst round rstrip scanf sha1 sha256 shellquote size slice sort split sprintf step
syn keyword puppetFunction strftime strip tag tagged template type unique unwrap upcase values versioncmp with yaml_data

" deprecated Core functions
syn keyword puppetDeprecated import

" puppet bolt functions
syn keyword puppetFunction add_facts add_to_group apply apply_prep background catch_errors
syn match puppetFunction "\<ctrl::do_until\>"
syn match puppetFunction "\<ctrl::sleep\>"
syn match puppetFunction "\<dir::children\>"
syn keyword puppetFunction download_file fail_plan
syn match puppetFunction "\<file::delete\>"
syn match puppetFunction "\<file::exists\>"
syn match puppetFunction "\<file::join\>"
syn match puppetFunction "\<file::read\>"
syn match puppetFunction "\<file::readable\>"
syn match puppetFunction "\<file::write\>"
syn keyword puppetFunction get_resources get_target get_targets
syn match puppetFunction "\<log::debug\>"
syn match puppetFunction "\<log::error\>"
syn match puppetFunction "\<log::fatal\>"
syn match puppetFunction "\<log::info\>"
syn match puppetFunction "\<log::trace\>"
syn match puppetFunction "\<log::warn\>"
syn match puppetFunction "\<out::message\>"
syn match puppetFunction "\<out::verbose\>"
syn keyword puppetFunction parallelize prompt
syn match puppetFunction "\<prompt::menu\>"
syn keyword puppetFunction puppetdb_command puppetdb_fact puppetdb_query remove_from_group resolve_references resource
syn keyword puppetFunction run_command run_container run_plan run_script run_task run_task_with set_config set_feature
syn keyword puppetFunction set_resources set_var
syn match puppetFunction "\<system::env\>"
syn keyword puppetFunction upload_file vars wait wait_until_available without_default_logging write_file

" Stdlib functions
syn keyword puppetStdLibFunction any2array any2bool assert_private base64 basename bool2num bool2str clamp concat
syn keyword puppetStdLibFunction convert_base count deep_merge defined_with_params delete delete_at delete_regex
syn keyword puppetStdLibFunction delete_undef_values delete_values deprecation difference dirname dos2unix enclose_ipv6
syn keyword puppetStdLibFunction ensure_resource ensure_resources fact fqdn_uuid get_module_path getparam glob grep
syn keyword puppetStdLibFunction has_ip_address has_ip_network intersection is_a join_keys_to_values
syn keyword puppetStdLibFunction load_module_metadata loadjson loadyaml member min num2bool parsejson parseyaml pick
syn keyword puppetStdLibFunction pick_default prefix pry range regexpescape reject reverse shell_join shell_split shuffle squeeze
syn match puppetStdLibFunction "\<stdlib::batch_escape\>"
syn match puppetStdLibFunction "\<stdlib::crc32\>"
syn match puppetStdLibFunction "\<stdlib::deferrable_epp\>"
syn match puppetStdLibFunction "\<stdlib::end_with\>"
syn match puppetStdLibFunction "\<stdlib::ensure\>"
syn match puppetStdLibFunction "\<stdlib::ensure_packages\>"
syn match puppetStdLibFunction "\<stdlib::extname\>"
syn match puppetStdLibFunction "\<stdlib::fqdn_rand_string\>"
syn match puppetStdLibFunction "\<stdlib::fqdn_rotate\>"
syn match puppetStdLibFunction "\<stdlib::has_function\>"
syn match puppetStdLibFunction "\<stdlib::has_interface_with\>"
syn match puppetStdLibFunction "\<stdlib::ip_in_range\>"
syn match puppetStdLibFunction "\<stdlib::merge\>"
syn match puppetStdLibFunction "\<stdlib::nested_values\>"
syn match puppetStdLibFunction "\<stdlib::os_version_gte\>"
syn match puppetStdLibFunction "\<stdlib::parsehocon\>"
syn match puppetStdLibFunction "\<stdlib::powershell_escape\>"
syn match puppetStdLibFunction "\<stdlib::seeded_rand\>"
syn match puppetStdLibFunction "\<stdlib::seeded_rand_string\>"
syn match puppetStdLibFunction "\<stdlib::sha256\>"
syn match puppetStdLibFunction "\<stdlib::shell_escape\>"
syn match puppetStdLibFunction "\<stdlib::sort_by\>"
syn match puppetStdLibFunction "\<stdlib::start_with\>"
syn match puppetStdLibFunction "\<stdlib::str2resource\>"
syn match puppetStdLibFunction "\<stdlib::time\>"
syn match puppetStdLibFunction "\<stdlib::to_json\>"
syn match puppetStdLibFunction "\<stdlib::to_json_pretty\>"
syn match puppetStdLibFunction "\<stdlib::to_python\>"
syn match puppetStdLibFunction "\<stdlib::to_ruby\>"
syn match puppetStdLibFunction "\<stdlib::to_toml\>"
syn match puppetStdLibFunction "\<stdlib::to_yaml\>"
syn match puppetStdLibFunction "\<stdlib::type_of\>"
syn match puppetStdLibFunction "\<stdlib::validate_domain_name\>"
syn match puppetStdLibFunction "\<stdlib::validate_email_address\>"
syn match puppetStdLibFunction "\<stdlib::xml_encode\>"
syn keyword puppetStdLibFunction str2bool str2saltedpbkdf2 str2saltedsha512 suffix swapcase to_bytes union unix2dos
syn keyword puppetStdLibFunction uriescape validate_augeas validate_cmd validate_x509_rsa_key_pair values_at zip

" Stdlib deprecated functions, as of 9.6.0
syn keyword puppetDeprecated batch_escape ensure_packages fqdn_rand_string fqdn_rotate has_interface_with merge
syn keyword puppetDeprecated os_version_gte parsehocon parsepson powershell_escape seeded_rand seeded_rand_string shell_escape
syn match puppetDeprecated "\<stdlib::time\>"
syn keyword puppetDeprecated time to_json to_json_pretty to_python to_ruby to_toml to_yaml type_of validate_domain_name
syn keyword puppetDeprecated validate_email_address validate_legacy

" Core data types
syn keyword puppetType Any Array Binary Boolean Callable CatalogEntry Class Collection Data Default Deferred Enum Error
syn keyword puppetType Float Hash Init Integer Iterable Iterator NotUndef Numeric Object Optional Pattern Regexp
syn keyword puppetType Resource RichData Runtime Scalar ScalarData SemVer SemVerRange Sensitive String Struct TimeSpan
syn keyword puppetType Timestamp Tuple Type TypeSet Undef URI Variant

" Bolt data types
syn keyword puppetType ApplyResult ContainerResult Future ResourceInstance Result ResultSet Target TargetSpec PlanResult

" Core resource types
syn keyword puppetType exec file filebucket group notify package resources schedule service stage tidy user

" supported resource types
syn keyword puppetType augeas cron host mount scheduled_task selboolean selmodule ssh_authorized_key sshkey yumrepo zfs zone zpool

" resource types by Puppet, inc but available on forge
syn keyword puppetType k5login mailalias maillist

" deprecated resource types
syn keyword puppetDeprecated computer interface macauthorization mcx nagios_command nagios_contact nagios_contactgroup
syn keyword puppetDeprecated nagios_host nagios_hostdependency nagios_hostescalation nagios_hostextinfo
syn keyword puppetDeprecated nagios_hostgroup nagios_service nagios_servicedependency nagios_serviceescalation
syn keyword puppetDeprecated nagios_serviceextinfo nagios_servicegroup nagios_timeperiod router vlan

" Normal String {{{1
syn region puppetString matchgroup=puppetStringDelimiter start="\"" end="\"" skip="\\\\\|\\\"" contains=@puppetStringSpecial
syn region puppetString matchgroup=puppetStringDelimiter start="'" end="'" skip="\\\\\|\\'" contains=puppetQuoteEscape

" Normal Regular Expression {{{1
syn region puppetRegexp matchgroup=puppetRegexpDelimiter start="\%(\%(^\|\<\%(and\|or\|while\|until\|unless\|if\|elsif\|when\|not\|then\|else\)\|[;\~=!|&(,{[<>?:*+-]\)\s*\)\zs/" end="/" skip="\\\\\|\\/" contains=@puppetRegexpSpecial
syn region puppetRegexp matchgroup=puppetRegexpDelimiter start="\%(\h\k*\s\+\)\zs/[ \t=]\@!" end="/" skip="\\\\\|\\/" contains=@puppetRegexpSpecial

" Here Document {{{1
syn region puppetHeredocStart matchgroup=puppetStringDelimiter start=+@(\s*\%("[^"]\+"\|\w\+\)\%(/[nrtsuL$\\]*\)\=)+ end=+$+ oneline contains=ALLBUT,@puppetNotTop

syn region puppetString start=+@(\s*"\z([^"]\+\)"\%(/[nrtsuL$\\]*\)\=+hs=s+2  matchgroup=puppetStringDelimiter end=+^\s*|\=\s*-\=\s*\zs\z1$+ contains=puppetHeredocStart,@puppetStringSpecial keepend
syn region puppetString start=+@(\s*\z(\w\+\)\%(/[nrtsuL$\\]*\)\=+hs=s+2  matchgroup=puppetStringDelimiter end=+^\s*|\=\s*-\=\s*\zs\z1$+ contains=puppetHeredocStart		    keepend

" comments last overriding everything else
syn match   puppetComment       "\s*#.*$" contains=puppetTodo,puppetSpaceError,@Spell
syn region  puppetComment       start="/\*" end="\*/" contains=puppetTodo,puppetSpaceError,@Spell extend
syn keyword puppetTodo          TODO NOTE FIXME XXX BUG HACK contained

hi def link puppetStringDelimiter Delimiter
hi def link puppetRegexpDelimiter Delimiter
hi def link puppetRegexp          puppetConstant
hi def link puppetConstant        Constant
hi def link puppetNoInterpolation puppetString
hi def link puppetString          String
hi def link puppetBareWordString  String
hi def link puppetFloat           Float
hi def link puppetInteger         Number
hi def link puppetBoolean         Boolean
hi def link puppetType            Type
hi def link puppetBracket         Operator
hi def link puppetBrace           Operator
hi def link puppetParen           Operator
hi def link puppetOperator        Operator
hi def link puppetStructure       Structure
hi def link puppetName            puppetIdentifier
hi def link puppetVariable        puppetIdentifier
hi def link puppetIdentifier      Identifier
hi def link puppetInterpolationDelimiter Identifier
hi def link puppetConditional     Conditional
hi def link puppetRepeat          Repeat
hi def link puppetControl         Label
hi def link puppetKeyword         Keyword
hi def link puppetTodo            Todo
hi def link puppetComment         Comment
hi def link puppetIncludeFunction Include
hi def link puppetStdLibFunction  puppetFunction
hi def link puppetFunction        Function
hi def link puppetDeprecated      Todo
hi def link puppetDebug           Debug

if g:puppet_display_errors
  hi def link puppetInvalidNumber       Error
  hi def link puppetInvalidName         Error
  hi def link puppetSpaceError          Error
endif

let b:current_syntax = 'puppet'
