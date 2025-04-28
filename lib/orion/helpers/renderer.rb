# frozen_string_literal: true

# lib/orion/helpers/table_renderer.rb

require "tty-table"
require "pastel"

module Orion
  module Helpers
    module Renderer
      def self.render_table(rows:, fields: nil, headers: nil, format: :unicode)
        return "(no data)" if rows.empty?

        fields ||= rows.first.keys.map(&:to_sym)

        headers ||= fields.map { |f| f.to_s.capitalize }

        table_rows = rows.map do |row|
          fields.map { |f| row[f] || row[f.to_s] || "-" }
        end

        table = TTY::Table.new(header: headers, rows: table_rows)
        table.render(format)
      end

      def self.render_list(rows:)
        return "(no data)" if rows.empty?

        pastel = Pastel.new

        rows.each do |row|
          puts "\n"
          row.each do |key, value|
            label = pastel.cyan(key.to_s.split("_").map(&:capitalize).join(" "))

            formatted_value = case value
                              when Array
                                value.join(", ")
                              else
                                value.to_s
                              end

            colored_value = case key.to_s
                            when "name" then pastel.bold.white(formatted_value)
                            when "advisory", "title" then pastel.magenta(formatted_value)
                            when "cve" then pastel.red(formatted_value)
                            when "url" then pastel.blue(formatted_value)
                            when "patched_versions" then pastel.green(formatted_value)
                            else formatted_value
                            end

            puts "#{label}: #{colored_value}"
          end
          puts "\n"
          puts "-" * 40
        end
      end
    end
  end
end
