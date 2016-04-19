module EnhanceIO
  # Gather input character by character and do autocomplete based on items passed
  def self.input_auto(items)
    char = ""
    chars = []
    pos = 0
    rest_of_word = "" # acts as buffer for autocomplete

      while char != "\r"
          char = STDIN.getch.downcase

          if char == "\u007F" # backspace
            #Clear whole line using escape sequence \r to go to beginning of line
            print "\r" + " " * 80 + "\r"
            chars.pop
            print chars.join
            pos -= 1
            rest_of_word = "" # clear autocomplete buffer
          elsif char == "\r" # Return
            #Clear whole line using escape sequence \r to go to beginning of line
            print "\r" + " " * 80 + "\r"
            puts chars.join + rest_of_word
            break
          elsif char == "\t" # Tab
            # Clear whole line using escape sequence \r to go to beginning of line
            # Define whole word (chars)
            print "\r" + " " * 80 + "\r"
            print chars.join + rest_of_word
            chars = chars + rest_of_word.chars
            rest_of_word = ""
            #break
          elsif char == "\u0003" # CTRL-C or Return
            #Clear whole line using escape sequence \r to go to beginning of line
            print "\r" + " " * 80 + "\r"
            puts chars.join + rest_of_word
            exit # Stop program execution
          # elsif char == "\e" # other cases, such as arrow keys
            # For future: http://www.alecjacobson.com/weblog/?p=75
            # Arrow keys send \e, [, a as different characters.
            # So for now; this case is not fully implemented.
          else
            pos += 1
            print char
            chars << char # Put the character typed into array chars

            # Compare each word so far, with items to see if a match
            found_item = 0
            for item in items
              if chars.join == item.downcase.slice(0,pos)
                if found_item == 0
                  # found_item set to one will stop searching array after first match if there are multiple matches
                  found_item = 1
                  print " " * 80 # clear line from current position
                  (1..80).each { print "\e[D" } # go back 80 spaces
                  rest_of_word = item.downcase.slice(pos, item.length)
                  print rest_of_word.reverse_color
                  #print "K"
                  cursor_pos = pos + rest_of_word.length
                  (1..rest_of_word.length).each { print "\e[D" }
                end # if
              elsif found_item == 0
                # Occurs when hitting a different letter once autocomplete has started,
                # or if there was never a match.
                rest_of_word = ""
                print " " * 80 # clear line from current position
                (1..80).each { print "\e[D" } # go back 80 spaces
              end # if
            end # for
          end # if
      end # while
      return chars.join + rest_of_word
  end # def
end
