/* 

La Artimaña de Galton 

*/

let Engine, World, Bodies, Composite;
let engine, world;

const cfg = {
  // Escala general
  spacing: 18,
  pegR: 4.0,
  ballR: 2.9,

  // Dinámica global
  restitutionBall: 0.25,   // ↓ rebote para apilado estable (antes 0.451)
  gravityY: 1.80,
  frictionAirBall: 0.012,  // ↑ amortiguación
  frictionBall: 0.015,

  // Grilla (n decisiones = filas → n+1 canales)
  rows: 25,
  cols: null,              // si es null, se calcula como rows + 7
  dropEvery: 1,
  maxBalls: 2025,

  // Embudo curvo (sin tocar la grilla)
  funnelRadius: 97,
  funnelThickness: 30,
  funnelSegments: 36,      // ↑ resolución
  funnelOverlap: 0.6,      // solape relativo de segmentos

  // Canales verticales
  channelH: 220,
  wallThick: 2
};

let W = 800, H = 860;
let centerX;

let pegs = [];
let balls = [];
let walls = [];
let channelWalls = [];

let numBins, binW, binsStartX;
let boardTopY, boardBottomY, binsTopY, binsBottomY;
let gridCols;

// subpasos del solver para evitar “tunnelling” y vibraciones
const SUBSTEPS = 3;

function setup() {
  const host = document.getElementById('p5') || document.body;
  const c = createCanvas(W, H);
  c.parent(host);

  Engine = Matter.Engine;
  World  = Matter.World;
  Bodies = Matter.Bodies;
  Composite = Matter.Composite;

  engine = Engine.create();
  engine.positionIterations   = 12; // ↑
  engine.velocityIterations   = 8;
  engine.constraintIterations = 4;
  engine.enableSleeping       = true; // dormir cuerpos en reposo
  world  = engine.world;
  world.gravity.y = cfg.gravityY;

  centerX = width * 0.5;

  // Geometría principal
  numBins      = cfg.rows + 1;
  binW         = cfg.spacing;
  gridCols     = cfg.cols ?? (cfg.rows + 7);

  // Grilla más arriba
  boardTopY    = 180;
  boardBottomY = boardTopY + (cfg.rows - 1) * cfg.spacing;

  // Canales bajo la grilla
  binsTopY     = boardBottomY + 30;
  binsBottomY  = binsTopY + cfg.channelH;

  // Ancho de canales (centrados)
  binsStartX   = centerX - (numBins * binW) / 2;

  // Paredes exteriores
  addStaticRect(centerX, height - 10, width, 20);    // piso
  addStaticRect(10, height / 2, 20, height);         // pared izq
  addStaticRect(width - 10, height / 2, 20, height); // pared der

  // Embudo limpio (curvo) por encima de boardTopY
  buildFunnelArcs();

  // Grilla homogénea intercalada
  buildPegsHomogeneous();

  // Canales verticales de acumulación
  buildChannels();

  frameRate(60);
}

function draw() {
  clear(); // fondo claro definido por CSS/UA
  stepEngine();

  // Goteo de bolitas (sin saturar)
  if (frameCount % cfg.dropEvery === 0 && activeBallCount() < cfg.maxBalls) {
    dropBall();
  }

  // Pernos
  noStroke();
  fill("#A2976E2D");
  for (const p of pegs) circle(p.position.x, p.position.y, cfg.pegR * 2);

  // Paredes y canales
  fill("#A2976E11");
  for (const w of walls) drawBodyAsRect(w);
  for (const s of channelWalls) drawBodyAsRect(s);

  // Bolitas rojas
  fill("#D62D00");
  drawBalls();
}

/* ================= Motor ================= */

function stepEngine() {
  const dt = 1000 / 60;
  for (let i = 0; i < SUBSTEPS; i++) {
    Matter.Engine.update(engine, dt / SUBSTEPS);
  }
}

/* ================= Construcción ================= */

function buildPegsHomogeneous() {
  pegs.length = 0;

  const totalGridW = (gridCols - 1) * cfg.spacing;
  const gridStartX = centerX - totalGridW / 2;

  for (let r = 0; r < cfg.rows; r++) {
    const y = boardTopY + r * cfg.spacing;
    const rowOffset = (r % 2 === 0) ? 0 : cfg.spacing / 2;

    for (let c = 0; c < gridCols; c++) {
      const x = gridStartX + c * cfg.spacing + rowOffset;
      const peg = Bodies.circle(x, y, cfg.pegR, {
        isStatic: true,
        friction: 0,
        frictionStatic: 0,
        restitution: 0,
        slop: 0.25
      });
      World.add(world, peg);
      pegs.push(peg);
    }
  }
}

function buildChannels() {
  channelWalls.length = 0;

  const t = cfg.wallThick;

  // Pared izquierda y derecha del conjunto de canales
  const leftWallX  = binsStartX - t / 2;
  const rightWallX = binsStartX + numBins * binW + t / 2;
  addChannelWall(leftWallX,  (binsTopY + binsBottomY) / 2, t, cfg.channelH);
  addChannelWall(rightWallX, (binsTopY + binsBottomY) / 2, t, cfg.channelH);

  // Separadores verticales entre canales
  for (let i = 1; i < numBins; i++) {
    const x = binsStartX + i * binW;
    addChannelWall(x, (binsTopY + binsBottomY) / 2, t, cfg.channelH);
  }

  // Suelo común de los canales (engrosado y con fricción)
  addStaticRect(centerX, binsBottomY, numBins * binW + t * 5, t * 5);
}

function buildFunnelArcs() {
  const cy = 120; // centro vertical del embudo
  const cx = centerX;
  const R  = cfg.funnelRadius;
  const th = cfg.funnelThickness;
  const segs = cfg.funnelSegments;
  const overlap = cfg.funnelOverlap * th; // solape para sellar juntas

  // Embudo simétrico reducido (sin interferir con la grilla)
  const offsetX = 103;

  addArcWall(cx - offsetX, cy, R, radians(0),   radians(-55), th, segs, overlap); // izq
  addArcWall(cx + offsetX, cy, R, radians(180), radians(235), th, segs, overlap); // der
}

// arco aproximado con rectángulos estáticos, solapados
function addArcWall(cx, cy, r, a0, a1, thickness = 10, segments = 24, overlap = 0) {
  for (let i = 0; i < segments; i++) {
    const t0 = lerp(a0, a1, i / segments);
    const t1 = lerp(a0, a1, (i + 1) / segments);
    const tm = (t0 + t1) * 0.5;
    const len = Math.abs(r * (t1 - t0)) + overlap;

    const x = cx + (r - thickness / 2) * Math.cos(tm);
    const y = cy + (r - thickness / 2) * Math.sin(tm);

    const rect = Bodies.rectangle(x, y, len, thickness, {
      isStatic: true,
      angle: tm + Math.PI / 2,
      restitution: 0,
      friction: 0.2,
      frictionStatic: 1.0,
      slop: 0.3
    });
    World.add(world, rect);
    walls.push(rect);
  }
}

function addStaticRect(x, y, w, h, angle = 0) {
  const b = Bodies.rectangle(x, y, w, h, {
    isStatic: true,
    angle,
    restitution: 0,
    friction: 0.25,
    frictionStatic: 1.0,
    slop: 0.3
  });
  World.add(world, b);
  walls.push(b);
}
function addChannelWall(x, y, w, h) {
  const b = Bodies.rectangle(x, y, w, h, {
    isStatic: true,
    restitution: 0,
    friction: 0.3,
    frictionStatic: 1.0,
    slop: 0.3
  });
  World.add(world, b);
  channelWalls.push(b);
}

/* ================= Dinámica ================= */

function dropBall() {
  const jitterX = random(-binW * 0.25, binW * 0.25);
  const r = cfg.ballR * random(0.95, 1.05);

  const b = Bodies.circle(centerX + jitterX, 10, r, {
    restitution: cfg.restitutionBall,
    friction: cfg.frictionBall,
    frictionAir: cfg.frictionAirBall,
    density: 0.001,
    sleepThreshold: 30 // se duermen antes
  });
  World.add(world, b);
  balls.push(b);
}

const REST_SPEED   = 0.18;
const REST_ANG     = 0.02;
const REST_FRAMES  = 24;
const VMAX         = 15;

function drawBalls() {
  const keep = [];
  for (const b of balls) {
    const { x, y } = b.position;
    circle(x, y, b.circleRadius * 2);

    // Límite de velocidad para evitar atraviesos
    if (!b.isStatic && b.speed > VMAX) {
      const s = VMAX / b.speed;
      Matter.Body.setVelocity(b, { x: b.velocity.x * s, y: b.velocity.y * s });
    }

    // Descarta si se sale de pantalla
    if (y > height + 200 || x < -200 || x > width + 200) {
      World.remove(world, b);
      continue;
    }

    // Zona de canales: detectar reposo y congelar
    if (!b.isStatic && y >= binsTopY - 2) {
      const v  = b.speed;
      const av = Math.abs(b.angularSpeed);
      b._rest = (b._rest || 0);
      if (v < REST_SPEED && av < REST_ANG) {
        b._rest++;
        if (b._rest >= REST_FRAMES) {
          Matter.Body.setVelocity(b, { x: 0, y: 0 });
          Matter.Body.setAngularVelocity(b, 0);
          Matter.Body.setStatic(b, true); // reposo estable (sin “latido”)
        }
      } else {
        b._rest = 0;
      }
    }

    keep.push(b);
  }
  balls = keep;
}

function activeBallCount() {
  return balls.length;
}

/* ================= Interacción ================= */

function keyPressed() {
  if (key === 'c' || key === 'C') {
    // Limpia bolitas
    for (const b of balls) World.remove(world, b);
    balls = [];
  }
}

/* ================= Utilidades visuales ================= */

// Dibuja un cuerpo rectangular de Matter con su rotación real.
function drawBodyAsRect(b) {
  push();
  translate(b.position.x, b.position.y);
  rotate(b.angle);
  rectMode(CENTER);

  if (b.vertices && b.vertices.length === 4) {
    const w = dist(b.vertices[0].x, b.vertices[0].y, b.vertices[1].x, b.vertices[1].y);
    const h = dist(b.vertices[1].x, b.vertices[1].y, b.vertices[2].x, b.vertices[2].y);
    rect(0, 0, w, h);
  } else {
    const w = b.bounds.max.x - b.bounds.min.x;
    const h = b.bounds.max.y - b.bounds.min.y;
    rect(0, 0, w, h);
  }
  pop();
}