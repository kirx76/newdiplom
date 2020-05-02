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


    $('.dishs_manipulate .plus').on('click', function () {
        $(this).parent().find('.count_of_dish').text(parseInt($(this).parent().find('.count_of_dish').text()) + 1);
        let dish_id = $(this).parent().find('input').val();
        $.ajax({
            method: "POST",
            url: "/adddish",
            data: {
                'dish_id': dish_id,
                'status': 1
            },
            success: function (data) {
                console.log(data)
            },
            error: function (data) {
                console.log(data)
            }
        })

    });
    $('.dishs_manipulate .minus').on('click', function () {
        if (parseInt($(this).parent().find('.count_of_dish').text()) >= 1) {
            $(this).parent().find('.count_of_dish').text(parseInt($(this).parent().find('.count_of_dish').text()) - 1);
            let dish_id = $(this).parent().find('input').val();
            $.ajax({
                method: "POST",
                url: "/adddish",
                data: {
                    'dish_id': dish_id,
                    'status': 0
                },
                success: function (data) {
                    console.log(data)
                },
                error: function (data) {
                    console.log(data)
                }
            })
        }
    });

    $('.dishs_block').on('click', function () {
        $(this).parent().find('.dishs_action').css('display', 'flex');
    });

    $('.close_dishs_action').on('click', function () {
        $(this).parent().hide();
    });

    $('#testbutton').on('click', function () {
        $.notify("Hello World");
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

});

