require_relative 'pages'

module Pillboxr
  class Result

    attr_accessor :record_count, :pages

    def initialize(api_response)
      initial_page_number = Integer(api_response.query.params.limit / RECORDS_PER_PAGE )
      @record_count = Integer(api_response.body['Pills']['record_count'])

      puts "#{@record_count} records available. #{RECORDS_PER_PAGE} records retrieved."

      @pages = initialize_pages_array(api_response, initial_page_number)
      @pages[initial_page_number].send(:pills=, self.class.parse_pills(api_response))
      return self
    end

    def self.subsequent(api_response)
      return parse_pills(api_response)
    end

    def self.parse_pills(api_response)
      pills = []
      if @record_count == 1
        pills << Pill.new(api_response.body['Pills']['pill'])
      else
        api_response.body['Pills']['pill'].each do |pill|
          pills << Pill.new(pill)
        end
      end
      return pills
    end

    def initialize_pages_array(api_response, initial_page_number)
      record_count.divmod(RECORDS_PER_PAGE).tap do |ary|
        if ary[1] == 0
          return Pages.new(ary[0]) do |i|
            page_params = api_response.query.params.dup
            page_params.delete_if { |param| param.respond_to?(:lower_limit)}
            page_params << Attributes::Lowerlimit.new(i * RECORDS_PER_PAGE)
            Page.new(i == initial_page_number, i == initial_page_number, i, [], page_params)
          end
        else
          return Pages.new(ary[0] + 1) do |i|
            page_params = api_response.query.params.dup
            page_params.delete_if { |param| param.respond_to?(:lower_limit)}
            page_params << Attributes::Lowerlimit.new(i * RECORDS_PER_PAGE)
            Page.new(i == initial_page_number, i == initial_page_number, i, [], page_params)
          end
        end
      end
    end

    def inspect
      string = "#<Pillboxr::Result:#{object_id} "
      instance_variables.each do |ivar|
        string << String(ivar)
        string << " = "
        string << (String(self.instance_variable_get(ivar)) || "")
        string << ", "
      end unless instance_variables.empty?
      string << ">"
      return string
    end

    alias_method :to_s, :inspect
    private :initialize_pages_array

    Page = Struct.new(:current, :retrieved, :number, :pills, :params) do
      # extend Pillboxr
      def inspect
        "<Page: current: #{current}, retrieved: #{retrieved}, number: #{number}, params: #{params}, #{pills.size} pills>"
      end

      def current?
        self.current == true
      end

      def retrieved?
        self.retrieved == true
      end

      def get
        unless self.retrieved
          self.pills = Result.subsequent(Request.new(self.params).perform)
          self.retrieved = true
        end
      end

      alias_method :to_s, :inspect
      private :current=, :retrieved=, :number=, :pills=, :params=
    end
  end
end