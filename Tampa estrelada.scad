// --- Parâmetros Exatos (em milímetros) ---
comprimento_haste = 21;  // 2.1 cm do centro até a ponta
largura_haste = 7;       // 0.7 cm de largura da haste
altura = 6;              // 0.6 cm de altura total da estrela
diametro_furo = 4;       // 0.4 cm de diâmetro do furo do parafuso

// Parâmetros da tampa central
raio_tampa = 4.5;        // 0.45 cm de raio (proporcional ao centro da estrela)
altura_tampa = 2.5;      // 0.25 cm de altura da tampa

// Resolução dos círculos para deixar bem redondo
$fn = 100;

// --- Montagem da Peça ---
difference() {
    union() {
        // 1. Corpo sólido da estrela
        linear_extrude(height = altura) {
            union() {
                // Círculo central para conectar as bases das hastes firmemente
                circle(d = largura_haste + 2); 
                
                // As 5 hastes
                for(i = [0 : 4]) {
                    rotate([0, 0, i * 72]) {
                        haste();
                    }
                }
            }
        }
        
        // 2. Tampa central
        translate([0, 0, altura]) {
            tampa_central();
        }
    }
    
    // 3. Furo do parafuso
    // O 'h = altura + 1' garante que o furo atravesse a estrela toda, 
    // mas não fure a tampa que está acima dela.
    translate([0, 0, -1])
        cylinder(d = diametro_furo, h = altura + 1); 
}

// --- Desenho do formato da haste ---
module haste() {
    // A ponta começa a afinar 3mm antes do fim para fazer o bico da estrela
    inicio_ponta = comprimento_haste - 3; 
    metade_largura = largura_haste / 2;
    
    polygon(points = [
        [0, metade_largura],
        [inicio_ponta, metade_largura],
        [comprimento_haste, 0],           // Bico exato no 21mm
        [inicio_ponta, -metade_largura],
        [0, -metade_largura]
    ]);
}

// --- Desenho da tampa central ---
module tampa_central() {
    passos = 6; // formação do domo
    altura_degrau = altura_tampa / passos;
    
    for(i = [0 : passos - 1]) {
        // Cria a curvatura arredondada da tampa
        raio_atual = raio_tampa * cos(i * 90 / passos);
        
        translate([0, 0, i * altura_degrau])
            cylinder(r = raio_atual, h = altura_degrau + 0.05);
    }
}