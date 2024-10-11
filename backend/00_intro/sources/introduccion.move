module cuenta:: proyecto {

use std::signer;

struct Contador has key, drop {valor: u64}

public entry fun publicar(cuenta: &signer, valor: u64){
    let recurso = Contador {valor};
    move_to(cuenta, recurso)
}

#[view]
public fun obtener_contador(direccion: address):u64 acquires Contador {
     borrow_global<Contador>(direccion).valor
}

public entry fun incrementar(cuenta: &signer)acquires Contador {
     let referencia = &mut borrow_global_mut<Contador>(signer::address_of(cuenta)).valor;
     *referencia = *referencia + 1
}
public entry fun decrementar(cuenta: &signer)acquires Contador {
     let referencia = &mut borrow_global_mut<Contador>(signer::address_of(cuenta)).valor;
     *referencia = *referencia - 1
}
public entry fun restablecer(cuenta: &signer)acquires Contador {
     let referencia = &mut borrow_global_mut<Contador>(signer::address_of(cuenta)).valor;
     *referencia = 0
}

#[view]
// public fun exists(direccion: address): bool {
//     exists<Contador>(direccion)
// }

public entry fun eliminar (cuenta: &signer) acquires Contador {
     move_from<Contador>(signer::address_of(cuenta));
}

}
// module introduccion::practica_aptos {
//     use std::debug::print;
//     use std::string::utf8;
//     use std::string::String;
//     use std::vector::{borrow, borrow_mut};
//     use aptos_std::string_utils::{to_string, debug_string};

//     struct Autor has drop {
//         nombre: String,
//         fecha_nacimiento: u16,
//     }

//     struct Libro has drop {

//         titulo: String,
//         autor: Autor,
//         publicado : u16,
//         tiene_audiolibro: bool,
//     }

//     fun practica() {
//         print(&utf8(b"Hello, World!"));
//         let autor = Autor{nombre :utf8(b"Pablo Cohelo"), fecha_nacimiento: 1947u16};
//         print(&debug_string(&autor));

//         let libro = Libro{
//             titulo: utf8(b"El Alquimista"),
//             autor,
//             publicado:1988u16,
//             tiene_audiolibro: true,
//         };
        
//         print(&debug_string(&libro));
//     }

//     #[test]
//     fun prueba() {
//         practica();
//     }
//}
