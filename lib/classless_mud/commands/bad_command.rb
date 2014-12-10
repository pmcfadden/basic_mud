module ClasslessMud
  module Commands
    class BadCommand
      def self.perform game, player, message
        if matches(message).any?
          player.puts <<EOS
Did you mean:
  #{matches(message).join(' ')}
EOS
        else
          player.puts 'You typed that wrong. Try again.'
        end
      end

      def self.matches message
        Suggestions.new(message.split(' ').first)
                   .matches(ClasslessMud::Commands::Commands.commands)
      end

      class Suggestions
        attr_reader :word

        def initialize(word)
          @word = word
        end

        def length
          word.length
        end

        def matches(potentials)
          potentials & all
        end

        def all
          deletions + transpositions + replacements
        end

        def deletions
          (0..length).map { |i| "#{word[0...i]}#{word[i+1..-1]}" }
        end

        def transpositions
          (0..length-1).map { |i| "#{word[0...i]}#{word[i+1, 1]}#{word[i,1]}#{word[i+2..-1]}" }
        end

        def replacements
          (0..length-1).inject([]) do |sum, i|
            sum += ('a'..'z').map { |c| "#{word[0...i]}#{c}#{word[i+1..-1]}" }
          end
        end
      end

    end
  end
end

# Copyright notice
#
# Significant portions of this class were referenced from https://github.com/nithinbekal/spellingbee
#
# Copyright (c) 2010 Nithin Bekal
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
