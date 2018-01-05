
(function($) {
    //Functions for deleta and adding class
    jQuery.fn.myAddClass = function (classTitle) {
        return this.each(function() {
            var oldClass = jQuery(this).attr("class");
            oldClass = oldClass ? oldClass : '';
            jQuery(this).attr("class", (oldClass+" "+classTitle).trim());
        });
    }
    jQuery.fn.myRemoveClass = function (classTitle) {
        return this.each(function() {
            var oldClassString = ' '+jQuery(this).attr("class")+' ';
            var newClassString = oldClassString.replace(new RegExp(' '+classTitle+' ','g'), ' ').trim()
            if (!newClassString)
                jQuery(this).removeAttr("class");
            else
                jQuery(this).attr("class", newClassString);
        });
    }


   //Starting if our graphics in on
    $(window).load(function () {
        // Получаем доступ к SVG DOM

        var svgobject = document.getElementById('bundesland');
        if ('contentDocument' in svgobject);
        var svgdom = svgobject.contentDocument;
        var art = svgdom.getElementsByClassName("highlight");


        // Хак для WebKit (чтобы правильно масштабировал нашу карту)
        var viewBox = svgdom.rootElement.getAttribute("viewBox").split(" ");
        var aspectRatio = viewBox[2] / viewBox[3];
        svgobject.height = parseInt(svgobject.offsetWidth / aspectRatio);

        $("#landkreise").hide();
        $("#landkreise_table").hide();

        $("#show_land_kreise").click(function() {
            $("#landkreise").show();
            $("#landkreise_table").show();
            $(svgdom.getElementsByClassName("land")).each(function () {
                var id =$(this).attr("id");
                $("#"+id,svgdom).myAddClass("hidden");
                $("#text"+id, svgdom).myAddClass("hidden");
            });
            $(this).attr('disabled', true);
            $("#show_bundeslander").attr('disabled', false);
            $("#lands").hide();
        });

        $("#show_bundeslander").click(function () {
            $("#landkreise").hide();
            $("#landkreise_table").hide();
            $(svgdom.getElementsByClassName("land")).each(function () {
                var id = $(this).attr("id");
                $("#"+id,svgdom).myRemoveClass("hidden");
                $("#text"+id,svgdom).myRemoveClass("hidden");
            });
        $(this).attr('disabled', true);
        $("#show_land_kreise").attr('disabled', false);
        $("#lands").show();
        });

        //Connection between map and table
        $("#lands input[type=checkbox]").click(function() {
            var row = $(this).parent().parent();
            console.log("row = ", row);
            var id = row.attr("id");
            console.log("id = ", id);
            if (this.checked) {
                row.addClass("selected");
                $("#"+id, svgdom).myAddClass("selected");

            } else {
                row.removeClass("selected");
                $("#"+id, svgdom).myRemoveClass("selected");
            }
        });


        // Highlight region on the map on button table click
        $("#lands tr").hover(
            function () {

                var id = $(this).attr("id");
                $("#"+id, svgdom).css({ fill: "#ff0000"});
            },
            function () {
                var id = $(this).attr("id");
                var attribut = $("#"+id, svgdom).attr("fill");
                $("#"+id, svgdom).css({fill: ""+ attribut});
            }
        );

        // Hightlight string in the table on button click on map
        $(svgdom.getElementsByClassName("land")).hover(
            function () {
                var id = $(this).attr("id");
                $("#lands #"+id).addClass("highlight");
            },
            function () {
                var id = $(this).attr("id");
                $("#lands #"+id).removeClass("highlight");
            }
        );


        //Change values on the map from table values
        $("input[name=tabledata]").on("custom", function (e, descnum) {

            var compare = Array();
            var itterator = 0;

            $("#lands tbody tr").each(function() {
                var id = $(this).attr("id");
                var value = $(this).children(":nth-child("+descnum+")").text();
                compare[itterator] = {"id_elemet":id, "value_element": value};
                itterator++;
                $("#text"+id, svgdom).text(value);
            });
            compare.sort(function (a,b) {
                return a.value_element - b.value_element;
            });

            var color_array =  ["Cornsilk","Bisque","NavajoWhite","Wheat ",
                "BurlyWood", "Tan", "RosyBrown", "SandyBrown", "Goldenrod",
                "DarkGoldenrod", "Peru", "Chocolate", "SaddleBrown", "Sienna",
                "Brown", "Maroon"];
            $.each(compare, function (id, value) {
                if (color_array.length == compare.length) {
                    $("#" + compare[id].id_elemet, svgdom).attr("fill", ""+ color_array[id]);
                    // $("#" + compare[id].id_elemet, svgdom).css({fill: "" + color_array[id]});
                    $("#" + compare[id].id_elemet,svgdom).css({fill: ""+ color_array[id]});
                }
            });

        });

        $("input[name=tabledata]").trigger("custom", ["2"]);

        $("input[name=tabledata]").click(function () {

            var descnum = $(this).parent().prevAll().length+1;
            $(this).trigger("custom", descnum);
        });

        $("#resetswitch").change(function () {
            $("#lands tbody tr").each(function() {
                var id = $(this).attr("id");
                $("#text"+id, svgdom).text("");

            });
        });

        // Pop - Up Tipps
        $(svgdom.getElementsByClassName("land")).tooltip({
            track: true,
            delay: 0,
            showURL: false,
            fade: 250,
            bodyHandler: function() {
                console.log("Zashli------------------");
                var id     = $(this).attr("id");
                var area   = $("#lands #"+id+" td:nth-child(2)").text();
                console.log("AREA TEXT-----", area);
                var result = $("<p>").append($("<strong>").text(area));
                $("#lands #"+id+" td:nth-child(2)").nextAll().each(function(){
                    var pos = $(this).prevAll().length+1;
                    var title = $("#lands thead th:nth-child("+pos+")").text();
                    var value = $(this).text();
                    result.append($("<p>").text(title + ": " + value));
                });
                return result;
            }
        });
    });
})(jQuery);
