module Features
  module InputHelpers
    def select2(input_id,search_term,record_id,record_text)
      page.execute_script <<-JS
        $('#{input_id}').select2("open"); // open select2
        $('.select2-search__field').val("#{search_term}").trigger('keyup'); // emulate typing
      JS

      sleep(0.5) # wait for ajax to return

      # emulate selecting search result
      page.execute_script <<-JS
       $('#{input_id}').select2("trigger", "select", {
            data: { id: "#{record_id}", text: "#{record_text}" }
        });
      JS
    end
  end
end
