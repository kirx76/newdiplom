$(document).ready(function () {
    // $('.dishtypes div').hover(
    //     function () {
    //         $('.dishtypes_name').hide();
    //     setTimeout(() => {
    //         $(this).find('.dishtypes_name').show();
    //     }, 300)
    // },
    //     function () {
    //         $(this).find('.dishtypes_name').hide();
    //     })


    // $('.dishs_manipulate .plus').on('click', function () {
    //     $(this).parent().find('.count_of_dish').text(parseInt($(this).parent().find('.count_of_dish').text()) + 1);
    //     let dish_id = $(this).parent().find('input').val();
    //     $.ajax({
    //         method: "POST",
    //         url: "/adddish",
    //         data: {
    //             'dish_id': dish_id,
    //             'status': 1
    //         },
    //         success: function (data) {
    //             console.log(data)
    //         },
    //         error: function (data) {
    //             console.log(data)
    //         }
    //     })
    //
    // });
    // $('.dishs_manipulate .minus').on('click', function () {
    //     if (parseInt($(this).parent().find('.count_of_dish').text()) >= 1) {
    //         $(this).parent().find('.count_of_dish').text(parseInt($(this).parent().find('.count_of_dish').text()) - 1);
    //         let dish_id = $(this).parent().find('input').val();
    //         $.ajax({
    //             method: "POST",
    //             url: "/adddish",
    //             data: {
    //                 'dish_id': dish_id,
    //                 'status': 0
    //             },
    //             success: function (data) {
    //                 console.log(data)
    //             },
    //             error: function (data) {
    //                 console.log(data)
    //             }
    //         })
    //     }
    // });

    $('.dishs_block').on('click', function () {
        let dish_id = $(this).data('dish_id');
        let user_id = $(this).data('user_id');
        $.ajax({
            method: 'POST',
            url: '/dishord',
            data: {
                'dish_id': dish_id,
                'user_id': user_id
            },
            success: function (data) {
                console.log(data);
                $('#dishordmodal .modal-content').html(data);
            },
            error: function (data) {
                console.log(data)
            },
        });
        $('#dishordmodal').modal();
        // $(this).parent().find('.dishs_action').css('display', 'flex');
    });

    $('.close_dishs_action').on('click', function () {
        $(this).parent().hide();
    });

    $('.basket-main').on('click', function () {
        $.ajax({
            method: "POST",
            url: "/getusrbasket",
            data: {},
            success: function (data) {
                // console.log(data);
                // console.log(jQuery.type(data));
                // let answer = jQuery.parseJSON(data);
                // console.log(jQuery.type(answer));
                // console.log(answer);
                // // let smt = JSON.parse(data);
                // // console.log(jQuery.type(smt));
                // // console.log(smt);
                // console.log(answer[0]);
                // console.log($('#basketmodal .modal-content'))
                // // $('#basketmodal .modal-content').text(answer[0]['dish_description'])
                // // $.each(answer, function (i, item) {
                // //     let paster = ""
                // //     console.log(paster)
                // // });
                console.log(data);
                $('body').append(data)
            },
            error: function (data) {
                note({
                    content: jQuery.parseJSON(data.responseText).message.message,
                    type: "error",
                    time: 5
                })
            }
        });
        // $('#basketmodal').modal();
    });


    $(document).ready(function () {
        websocket.onmessage = function (evt) {
            var mess = evt.data;
            note({
                content: mess,
                type: "success",
                time: 5
            });
            websocket.onerror = function (evt) {
                console.log(evt);
            }
        }
    });

    $('.clean').on('click', function () {
        $(this).prev().val('');
    });


    $("select").on("click", function () {

        $(this).parent(".select-box").toggleClass("open");

    });

    $(document).mouseup(function (e) {
        var container = $(".select-box");

        if (container.has(e.target).length === 0) {
            container.removeClass("open");
        }
    });


    $("select").on("change", function () {

        var selection = $(this).find("option:selected").text(),
            labelFor = $(this).attr("id"),
            label = $("[for='" + labelFor + "']");

        label.find(".label-desc").html(selection);

    });


//    МАСКИ ДЛЯ ТЕЛЕФОНОВ
    $(document).ready(function () {
        $('#notuser_phone').mask("8(999) 999-9999");
        $('#user_phone').mask("8(999) 999-9999");
        $('input[name="phonereg"]').mask("8(999) 999-9999");
        $('input[name="phoneauth"]').mask("8(999) 999-9999");
        $('#notuser_phone').mask("8(999) 999-9999")
    });

//    КОНЕЦ МАСОК

});

