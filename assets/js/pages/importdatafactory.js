$(function () {
    // datatables
    altair_datatables.dt_individual_search();
});

altair_datatables = {
    dt_individual_search: function () {
        var $dt_individual_search = $('#dt_individual_search');
        if ($dt_individual_search.length) {

            // Setup - add a text input to each footer cell
            $dt_individual_search.find('tfoot th').each(function () {
                var title = $dt_individual_search.find('tfoot th').eq($(this).index()).text();
                $(this).html('<input type="text" class="md-input" placeholder="' + title + '" />');
            });

            // reinitialize md inputs
            altair_md.inputs();

            // DataTable
            var individual_search_table = $dt_individual_search.DataTable();

            // Apply the search
            individual_search_table.columns().every(function () {
                var that = this;

                $('input', this.footer()).on('keyup change', function () {
                    that
                        .search(this.value)
                        .draw();
                });
            });

        }
    }
};