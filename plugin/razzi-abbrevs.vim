inoremap <silent> <C-f> <C-o>:call InteractivelyAddAbolish()<cr>
" inoremap <C-f> <C-o>:call JustTellMeColumn()<cr>

let g:abbrevs_file = expand("<sfile>:p:h") . "/razzi-abbrevs-list.vim"
exec "source " . g:abbrevs_file

function! FindMatchingAbbrev(word)
  let abbrevs = system('cat ' . g:abbrevs_file)

  let lines = split(abbrevs, "\n")

  for line_text in lines
    let line = split(line_text)
    if line[1] == a:word
      return line[2]
    endif
  endfor

  return ""
endfunction

function! IsUpper(char)
  return char2nr('A') <= char2nr(a:char) && char2nr(a:char) <= char2nr('Z')
endfunction

function! TransferCase(source, target)
  " Apply the capitalization of the source word to the target word.
  " The target word is to be passed in as all lowercase.
  let result = ""
  let index = 0
  for target_letter in a:target
    let origin_letter = a:source[index]
    if IsUpper(origin_letter)
      let cased_letter = toupper(target_letter)
    else
      let cased_letter = target_letter
    endif

    let result .= cased_letter

    let index += 1
  endfor
  return result
endfunction

function! DoReplacement(replacement, start_eol)
  normal! gvd
  let special_char = LookingAtSpecialChar()
  let at_end_of_line = AtEndOfLine()
  " if at_end_of_line || special_char
  if a:start_eol
    let inserter = "a"
  else
    let inserter = "i"
  endif
  " let msg = input("i/a? " . inserter . " SPCL? " . special_char . " nowEOL? " . at_end_of_line . " wasEOL? " . a:start_eol)
  let cmd = "normal! " . inserter . a:replacement
  execute cmd
  if special_char
    call feedkeys("\<Right>")
  endif
endfunction

function! AtEndOfLine()
  return col("$") == col(".")
endfunction

function! CharUnderCursor()
  let column = col('.')
  let line = getline('.')
  let char = line[column - 1]
  return char
endfunction

function LookingAtSpace()
  let char = CharUnderCursor()
  return char == ' '
endfunction

function! LookingAtSpecialChar()
  return CharUnderCursor() < char2nr('0')
endfunction

function! DetermineReplacement(word)
  let matching_abbr = FindMatchingAbbrev(a:word)
  if matching_abbr != ""
    return matching_abbr
  endif

  let prompt = "Correction for " . a:word . ": "
  let correction = input(prompt, a:word)

  if (a:word == correction)
    return ""
  endif

  let abolish = "Abolish " . a:word . " " . correction
  execute abolish

  let old = readfile(g:abbrevs_file)
  call writefile(old + [abolish], g:abbrevs_file)
  return correction
endfunction

function! JustTellMeColumn()
  echom "COL is " . virtcol(".") . " and EOL: " . AtEndOfLine()
  messages
endfunction

function! InteractivelyAddAbolish()
  " normal mz
  let col = col(".")
  let started_at_eol = AtEndOfLine()

  " let msg = input("COL! " . col . " S EOL? " . started_at_eol)

  let on_space = LookingAtSpace()

  if LookingAtSpecialChar()
    normal! h
  endif

  normal! viw"ay
  normal! `>

  " Reset the cursor position in case the command is canceled
  " normal `z
  " if ! started_at_eol && ! AtEndOfLine() && !LookingAtSpace()
  "   call feedkeys("\<Right>")
  " endif

  let original_word = getreg('a')
  let word = tolower(original_word)

  let replacement = DetermineReplacement(word)

  if replacement == ""
    echo "\nabbrev failed, correction same as word"
    return
  endif

  let replacement = TransferCase(original_word, replacement)
  call DoReplacement(replacement, started_at_eol)
endfunction
