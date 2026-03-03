inoremap <C-f> <C-o>:call InteractivelyAddAbolish()<cr>

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

function! s:doSubstitute(from, to)
  let cmd = 'substitute/.*\zs' . a:from . '/' . a:to
  execute cmd
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

function! DoReplacement(original_word, replacement)
  call s:doSubstitute(a:original_word, a:replacement)
  normal `z

  " If the replacement is a different length than the original word, the
  " cursor will be off
  let original_chars = strchars(a:original_word)
  let replacement_chars = strchars(a:replacement)

  if original_chars < replacement_chars
    for i in range(1, replacement_chars - original_chars)
      normal l
    endfor
  elseif original_chars > replacement_chars
    for i in range(1, original_chars - replacement_chars)
      normal h
    endfor
  endif
endfunction

function! InteractivelyAddAbolish()
  normal mz
  let column = col('.')
  let line = getline('.')
  let char = line[column - 1]

  let end_of_line = col(".") == col("$") - 1

  if ! end_of_line || char == '"'
    normal! h
  endif

  normal! hviw"ay
  " Reset the cursor position in case the command is canceled
  normal `z

  let original_word = getreg('a')
  let word = tolower(original_word)

  let matching_abbr = FindMatchingAbbrev(word)

  if matching_abbr != ""
    let replacement = TransferCase(original_word, matching_abbr)
    call DoReplacement(original_word, replacement)
    return
  endif

  let prompt = "Correction for " . word . ": "
  let correction = input(prompt, word)

  if (word == correction)
    echo "\nabbrev failed, correction same as word"
    return
  endif

  let replacement = TransferCase(original_word, correction)

  call DoReplacement(original_word, replacement)

  let abolish = "Abolish " . word . " " . correction
  execute abolish

  let old = readfile(g:abbrevs_file)
  call writefile(old + [abolish], g:abbrevs_file)
endfunction
