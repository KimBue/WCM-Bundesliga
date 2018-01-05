
(function($) {
    $(window).load(function () {
        var kreis_id = "";
        var array_landkreise = "";
        var sachsen_landkreise = ["Bautzen", "Chemnitz", "Dresden", "Erzgebirgskreis",
            "Görlitz", "Leipzig-Stadt", "Leipzig-Landkreis", "Mittelsachsen", "Nordsachsen",
            "Sächsische Schweiz-Osterzgebirge", "Vogtlandkreis", "Zwickau"];

        var brandenburg_landkreise = ["Barnim", "Brandenburg an der Havel", "Cottbus",
            "Dahme-Spreewald", "Elbe-Elster", "Frankfurt (Oder)",
            "Havelland", "Märkisch-Oderland", "Oberhavel",
            "Oberspreewald-Lausitz", "Oder-Spree", "Ostprignitz-Ruppin",
            "Potsdam", "Potsdam-Mittelmark" , "Prignitz", "Spree-Neiße",
            "Teltow-Fläming", "Uckermark"];


        $("#filterText_landkreise").click(function () {
            var table_string_content = "";
            var i;
            var landkreis_value = $(this).val();

            switch (landkreis_value.toUpperCase()) {
                case "SACHSEN":
                    kreis_id = "sachsen_";
                    table_string_content = "";
                    array_landkreise = "";
                    $("#landkreise_table tbody tr").each(function () {
                        $(this).remove();
                    });
                    array_landkreise = sachsen_landkreise;
                    break;

                case "BRANDENBURG":
                    table_string_content = "";
                    array_landkreise = "";
                    kreis_id = "brandenburg_";
                    $("#landkreise_table tbody tr").each(function () {
                        $(this).remove();
                    });
                    array_landkreise = brandenburg_landkreise;
                    break;
                case "HAMBURG":
                    table_string_content = "";
                    array_landkreise = "";
                    kreis_id = "hamburg";
                    $("#landkreise_table tbody tr").each(function () {
                        $(this).remove();
                    });
                    array_landkreise = ["Hamburg"];
                    break;
                case "BREMEN":
                    table_string_content = "";
                    array_landkreise = "";
                    kreis_id = "bremen";
                    $("#landkreise_table tbody tr").each(function () {
                        $(this).remove();
                    });
                    array_landkreise=["Bremen"];
                    break;
                case "BERLIN":
                   table_string_content = "";
                   array_landkreise = "";
                   kreis_id = "berlin";
                   $("#landkreise_table tbody tr").each(function () {
                        $(this).remove();
                    });
                   array_landkreise = ["Berlin"];
                   break;
                default :
                       kreis_id = "";
                       table_string_content = "";
                       array_landkreise = "";

            }

            if (array_landkreise.length > 0) {
                var random_tore, random_rote, random_gelbe;
                  for (i = 0; i < array_landkreise.length; i++) {
                      console.log("Array_lankreise[i]", array_landkreise[i]);
                      random_tore = Math.floor(Math.random() * 120) + 63;
                      random_rote = Math.floor(Math.random() * 80) + 30;
                      random_gelbe = Math.floor(Math.random() * 95) + 40;
                      table_string_content += "<tr id='" + kreis_id + "'><td>" + array_landkreise[i] + "</td><td>"+ random_tore +"</td><td>" + random_rote + "</td><td>" + random_gelbe+"</td></tr>";
                  }

                $("#landkreise_table tbody").append(table_string_content);
              }

        });
    });

})(jQuery);
