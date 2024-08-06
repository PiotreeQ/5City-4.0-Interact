# 📂 Interact Menu Inspired on 5City 4.0 [ESX]
![image](https://github.com/user-attachments/assets/e96ec4e3-4d82-46d6-b6ce-7dec2cca7fed)
![image](https://github.com/user-attachments/assets/7cbc2545-df61-4215-bc5e-990b226cd933)

# Usage
```
-- This export will return id of target
exports['fc-interact']:addInteract({
    icon = 'fa-solid fa-box', -- optional (fontawesome.com)
    coords = vector3(0.0, 0.0, 0.0), -- coords or entity
    distance = 1.75,
    options = {
        {
           label = 'Buy Coffee',
           event = 'fc-interact:BuyCoffee',
           args = 10,
           job = 'police', -- it can be string, array, object
           canInteract = function() -- optional
               return true
           end
        }
    }
})

exports['fc-interact']:removeInteract(targetId)

exports['fc-interact']:disableInteract(true/false)
```
