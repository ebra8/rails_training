let fighters = ["🐉", "🐥", "🐊","💩", "🦍", "🐢", "🐩", "🦑", "🦀", "🐝", "🤖", "🐘", "🐸", "🕷","🐆", "🦕", "🦁"]

let stageEl = document.getElementById("stage")
let fightButton = document.getElementById("fightButton")

fightButton.addEventListener("click", function() {
    // Challenge:
    // When the user clicks on the "Pick Fighters" button, pick two random 
    // emoji fighters and display them as i.e. "🦀 vs 🐢" in the "stage" <div>.
    
    
    let randomIndex1 = Math.floor( Math.random()*17 )
    let randomIndex2 = Math.floor( Math.random()*17 )
    stageEl.textContent = fighters[randomIndex1] + " vs " + fighters[randomIndex2]
})
