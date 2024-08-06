const sleep = (delay) => new Promise((resolve) => setTimeout(resolve, delay));

const PushInteract = (async(data) => {
    $(`#interact-wrapper-${data.id}`).remove();
    let $newInteract = $(`
    <div class="interact-wrapper close-wrapper" id="interact-wrapper-${data.id}">
        <div class="key-box">E</div>
        <div class="options-list">
        </div>
    </div>`);
    $('body').append($newInteract);
    for (let i in data.options) {
        $(`#interact-wrapper-${data.id} .options-list`).append(`
        <div data-event="${data.options[i].event}" data-args="${data.options[i].args}" class="option-wrapper ${i == 0 ? `option-selected` : ``}">
            <div class="option-check"></div>
            <span>${data.options[i].label}</span>
        </div>`);
        await sleep(200);
    }
    $newInteract.css({
        top: data.position.top + 'px',
        left: data.position.left + 'px',
    })
})

window.addEventListener("message", (event) => {
    // discord.gg/piotreqscripts
    let data = event.data;
    switch(data.action) {
        case 'ShowInteract':
            if (data.type == 'circle') {
                $(`#interact-wrapper-${data.id}`).remove();
                let $newInteract = $(`
                <div class="interact-wrapper" id="interact-wrapper-${data.id}">
                    <div class="circle">
                        <i class="${data.icon}"></i>
                    </div>
                </div>`)
                $('body').append($newInteract);
                $newInteract.css({
                    top: data.position.top + 'px',
                    left: data.position.left + 'px',
                })
            } else if (data.type == 'all') {
                PushInteract(data);
            }
            break;
        case 'UpdateInteract':
            $(`#interact-wrapper-${data.id}`).css({
                top: data.top + 'px',
                left: data.left + 'px',
            })
            break;
        case 'HideInteract':
            $(`#interact-wrapper-${data.id}`).fadeOut(250);
            break;
        case 'SelectInteract':
            let selectedOption = $(`#interact-wrapper-${data.id} .option-selected`);
            let newSelected = selectedOption.siblings('.option-wrapper');
            if (newSelected.length < 1) return;

            selectedOption.removeClass('option-selected');
            newSelected.addClass('option-selected')
            break;
        case 'UseInteract':
            let selected = $(`#interact-wrapper-${data.id} .option-selected`);
            $.post('https://fc-interact/UseInteract', JSON.stringify({
                event: selected.attr('data-event'),
                args: selected.attr('data-args')
            }))
            break;
        // case 'ArrowDown':
        //     let selectedOption = $(`#interact-wrapper-${data.id} .option-selected`);
        //     console.log(selectedOption)
        //     break;
    }
})