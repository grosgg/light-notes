module Redcarpet
  module Render

    class Groscarpet < Redcarpet::Render::HTML
      def table(header, body)
        "<table class='table'><thead>#{header}</thead><tbody>#{body}</tbody></table>"
      end

      def superscript(text)
        "<span class='glyphicon glyphicon-#{text}'></span>"
      end
    end

  end
end