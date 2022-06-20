//Export Members Individually

/*export function add(a,b){
    print(a+b)
}

export function minus(a,b){
    print(a-b)
}

//Export Members Together

function add(a,b){
    print(a+b)
}

function minus(a,b){
    print(a-b)
}
export{add, minus}*/

//Export with Alias

function abc(a,b){
    print(a+b)
}

function bcd(a,b){
    print(a-b)
}
export{abc as add, bcd as minus}

//Export Default

export default function add1(a,b){
    print(a+b)
}