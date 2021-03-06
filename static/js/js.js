$(document).ready(function () {
    // var curdishcount = 0;
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
                $('#dishordmodal .modal-content').html(data);
                // console.log($('#prevval').val());
                // curdishcount = parseInt($('#prevval').val());
                // console.log($('#dishordmodal .modal-content').find('.count_of_dish').text());
            },
            error: function (data) {
            },
        });
        $('#dishordmodal').modal();
        // $(this).parent().find('.dishs_action').css('display', 'flex');
    });

    $('#dishordmodal').on('hidden.bs.modal', function () {
        if ($('#prevval')) {
            let curdishcount = parseInt($('#prevval').val());
            let exitcountdish = parseInt($('#dishordmodal .modal-content').find('.count_of_dish').text());
            if (exitcountdish > curdishcount) {
                note({
                    content: 'Блюда успешно добавлены в заказ',
                    type: "success",
                    time: 5
                })
            } else if (exitcountdish < curdishcount) {
                note({
                    content: 'Заказ в корзине обновлен',
                    type: "warn",
                    time: 5
                })
            }
        }
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
            let info = jQuery.parseJSON(evt.data)
            let isupdated = info['isupdated']
            if (isupdated === 'True' && window.location.pathname.search('clientorders')) {
                $.ajax({
                    method: "POST",
                    url: "/getneworderstat",
                    data: {
                        'order_id': info['order_id']
                    },
                    success: function (data) {
                        $(`[data-order_id="${info['order_id']}"]`).html(data)
                    },
                    error: function (data) {
                        console.log(data)
                    }
                })
            }
            note({
                content: info['message'],
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


    $('#customerorders').on('click', function () {
        let user_id = $(this).data('user_id');
        $.ajax({
            method: 'POST',
            url: '/customerorders',
            data: {
                'user_id': user_id
            },
            success: function (data) {
                console.log(data);
                $('#customerordersmodal .modal-content').html(data);
            },
            error: function (data) {
                console.log(data);
            },
        });
        $('#customerordersmodal').modal();
    });

    function sendadminajax(target) {
        $.ajax({
            method: "POST",
            url: "/admin",
            data: {
                'target': target
            },
            success: function (data) {
                console.log(data);
                $('.admin_tabs_content .maincontent').html(data);
                // console.log(1)
            },
            error: function (data) {
                console.log(data);
                // console.log(2)
            },
        })
    }

    $('.admin_tabs>div').on('click', function () {
        console.log($(this).find('span').text());
        $('.admin_tabs>div').each(function () {
            $(this).removeClass('active');
        });
        $(this).addClass('active');
        sendadminajax($(this).data('target'))
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

//    УВЕДОМЛЕНИЯ ВНЕ САЙТА


    function sendNotification(title, options) {
        if (!("Notification" in window)) {
            alert('Ваш браузер не поддерживает HTML Notifications, его необходимо обновить.');
        }

        else if (Notification.permission === "granted") {
            var notification = new Notification(title, options);

            function clickFunc() {
                alert('Пользователь кликнул на уведомление');
            }

            notification.onclick = clickFunc;
        }

        else if (Notification.permission !== 'denied') {
            Notification.requestPermission(function (permission) {
                if (permission === "granted") {
                    var notification = new Notification(title, options);

                } else {
                    alert('Вы запретили показывать уведомления'); // Юзер отклонил наш запрос на показ уведомлений
                }
            });
        } else {
        }
    }

//    КОНЕЦ УВЕДОМЛЕНИЙ ВНЕ САЙТА
});



