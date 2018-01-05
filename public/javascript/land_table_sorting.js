var lands = document.getElementById('lands');

lands.onclick = function(e) {
    if (e.target.tagName != 'TH') return;

    // Если TH -- сортируем
    sortGrid(e.target.cellIndex, e.target.getAttribute('data-type'));
};

function sortGrid(colNum, type) {
    var tbody = lands.getElementsByTagName('tbody')[0];

    // Составить массив из TR
    var rowsArray = [].slice.call(tbody.rows);

    // определить функцию сравнения, в зависимости от типа
    var compare;

    switch (type) {
        case 'number':
            compare = function(rowA, rowB) {
                return rowA.cells[colNum].innerHTML - rowB.cells[colNum].innerHTML;
            };
            break;
        case 'string':
            compare = function(rowA, rowB) {
                return rowA.cells[colNum].innerHTML > rowB.cells[colNum].innerHTML;
            };
            break;
    }

    // сортировать
    rowsArray.sort(compare);

    // Убрать tbody из большого DOM документа для лучшей производительности
    lands.removeChild(tbody);
    for(var i = rowsArray.length - 1; i >= 0 ; i--) {
        tbody.appendChild(rowsArray[i]);
    }

    lands.appendChild(tbody);

}

function myFunction(searching_text) {

    var input, filter, table, tr, td, i, j,res;
    filter = searching_text.toUpperCase();
    tr = lands.getElementsByTagName("tr");
    res = "";
    for (i = 1; i < tr.length; i++) {
        td = tr[i].getElementsByTagName("td");
        for (j = 0; j < td.length; j++) {
            var td_iterator;
            td_iterator = tr[i].getElementsByTagName("td")[j];
            res += td_iterator.innerHTML.toUpperCase();
        }
        if (res) {
            if ( (res.indexOf(filter) > -1) || (filter == "ALLE") ) { //value to search for never occurs
                tr[i].style.display = "";
                res = "";
            } else {
                tr[i].style.display = "none";
            }
        }
    }
}

