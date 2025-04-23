# frozen_string_literal: true

# lib/orion/helpers/table_renderer.rb

require "tty-table"

module Orion
  module Helpers
    # Responsible for rendering tables accross
    # Various CLI commands
    module TableRenderer
      def self.render(rows:, fields: nil, headers: nil, format: :unicode)
        return "(no data)" if rows.empty?

        fields ||= rows.first.keys.map(&:to_sym)

        headers ||= fields.map { |f| f.to_s.capitalize }

        table_rows = rows.map do |row|
          fields.map { |f| row[f] || row[f.to_s] || "-" }
        end

        table = TTY::Table.new(header: headers, rows: table_rows)
        table.render(format)
      end
    end
  end
end
