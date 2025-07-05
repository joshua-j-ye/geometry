class GeometryJump {
    constructor() {
        this.canvas = document.getElementById('gameCanvas');
        this.ctx = this.canvas.getContext('2d');
        this.gameRunning = false;
        this.gameStarted = false;

        // Game state
        this.score = 0;
        this.highScore = localStorage.getItem('geometryJumpHighScore') || 0;
        this.gameSpeed = 2;
        this.speedIncrement = 0.002;

        // Version info
        this.version = '1.0.0';
        this.loadVersionInfo();

        // Player properties
        this.player = {
            x: 100,
            y: 300,
            width: 30,
            height: 30,
            velocityY: 0,
            isJumping: false,
            jumpPower: -12,
            gravity: 0.6,
            color: '#4ECDC4'
        };

        // Ground
        this.ground = {
            y: 350,
            height: 50
        };

        // Obstacles
        this.obstacles = [];
        this.obstacleSpawnTimer = 0;
        this.obstacleSpawnRate = 150;

        // Background elements
        this.clouds = [];
        this.initClouds();

        // Particle effects
        this.particles = [];

        this.initEventListeners();
        this.updateHighScoreDisplay();
        this.gameLoop();
    }

    async loadVersionInfo() {
        try {
            // Try to fetch version from server (containerized deployment)
            const response = await fetch('/version.json');
            if (response.ok) {
                const versionData = await response.json();
                this.version = versionData.version;
            }
        } catch (error) {
            // Fallback to package.json version or default
            console.log('Using default version info');
        }

        // Update version display
        const versionElement = document.getElementById('version');
        if (versionElement) {
            versionElement.textContent = `v${this.version}`;
        }
    }

    initEventListeners() {
        // Start button
        document.getElementById('startBtn').addEventListener('click', (e) => {
            this.ensureMusic();
            this.startGame();
        });
        document.getElementById('restartBtn').addEventListener('click', (e) => {
            this.ensureMusic();
            this.restartGame();
        });

        // Keyboard controls
        document.addEventListener('keydown', (e) => {
            if (e.code === 'Space') {
                e.preventDefault();
                this.ensureMusic();
                if (!this.gameStarted) {
                    this.startGame();
                } else if (this.gameRunning) {
                    this.jump();
                } else {
                    this.restartGame();
                }
            }
        });

        // Mouse/touch controls
        this.canvas.addEventListener('click', () => {
            this.ensureMusic();
            if (!this.gameStarted) {
                this.startGame();
            } else if (this.gameRunning) {
                this.jump();
            }
        });

        // Touch controls for mobile
        this.canvas.addEventListener('touchstart', (e) => {
            e.preventDefault();
            this.ensureMusic();
            if (!this.gameStarted) {
                this.startGame();
            } else if (this.gameRunning) {
                this.jump();
            }
        });
    }

    ensureMusic() {
        // Only create the Audio object once
        if (!this.backgroundMusic) {
            this.backgroundMusic = new Audio('background-music.mp3');
            this.backgroundMusic.loop = true;
            this.backgroundMusic.volume = 0.5;
        }
        // Play if not already playing
        if (this.backgroundMusic.paused) {
            this.backgroundMusic.currentTime = 0;
            this.backgroundMusic.play().catch((err) => {
                // Log only once per session
                if (!this._musicWarned) {
                    console.warn('Music play error:', err);
                    this._musicWarned = true;
                }
            });
        }
    }

    initClouds() {
        for (let i = 0; i < 5; i++) {
            this.clouds.push({
                x: Math.random() * this.canvas.width,
                y: Math.random() * 150 + 50,
                width: Math.random() * 60 + 40,
                height: Math.random() * 30 + 20,
                speed: Math.random() * 0.5 + 0.2
            });
        }
    }

    startGame() {
        this.gameRunning = true;
        this.gameStarted = true;
        this.score = 0;
        this.gameSpeed = 2;
        this.obstacles = [];
        this.particles = [];
        this.obstacleSpawnTimer = 0;

        // Reset player
        this.player.y = 300;
        this.player.velocityY = 0;
        this.player.isJumping = false;

        // Hide start button, show game
        document.getElementById('startBtn').style.display = 'none';
        document.getElementById('gameOver').style.display = 'none';
        document.getElementById('restartBtn').style.display = 'none';
        // Music is handled by ensureMusic()
    }

    restartGame() {
        this.startGame();
    }

    jump() {
        if (!this.player.isJumping) {
            this.player.velocityY = this.player.jumpPower;
            this.player.isJumping = true;
            this.createJumpParticles();
        }
    }

    createJumpParticles() {
        for (let i = 0; i < 5; i++) {
            this.particles.push({
                x: this.player.x + this.player.width / 2,
                y: this.player.y + this.player.height,
                velocityX: Math.random() * 4 - 2,
                velocityY: Math.random() * 2 + 1,
                size: Math.random() * 3 + 2,
                life: 30,
                maxLife: 30,
                color: `hsl(${Math.random() * 60 + 30}, 70%, 60%)`
            });
        }
    }

    updatePlayer() {
        // Apply gravity
        this.player.velocityY += this.player.gravity;
        this.player.y += this.player.velocityY;

        // Ground collision
        if (this.player.y + this.player.height >= this.ground.y) {
            this.player.y = this.ground.y - this.player.height;
            this.player.velocityY = 0;
            this.player.isJumping = false;
        }

        // Rotation effect when jumping
        this.player.rotation = this.player.isJumping ? this.player.velocityY * 0.1 : 0;
    }

    spawnObstacle() {
        this.obstacles.push({
            x: this.canvas.width,
            y: this.ground.y - 30,
            width: 30,
            height: 30,
            color: '#FF6B6B'
        });
    }

    updateObstacles() {
        // Spawn obstacles
        this.obstacleSpawnTimer++;
        if (this.obstacleSpawnTimer >= this.obstacleSpawnRate) {
            this.spawnObstacle();
            this.obstacleSpawnTimer = 0;
            // Gradually decrease spawn rate (increase difficulty)
            this.obstacleSpawnRate = Math.max(80, this.obstacleSpawnRate - 0.5);
        }

        // Update obstacle positions
        for (let i = this.obstacles.length - 1; i >= 0; i--) {
            this.obstacles[i].x -= this.gameSpeed;

            // Remove obstacles that are off screen
            if (this.obstacles[i].x + this.obstacles[i].width < 0) {
                this.obstacles.splice(i, 1);
                this.score += 10;
                this.updateScoreDisplay();
            }
        }

        // Increase game speed gradually
        this.gameSpeed += this.speedIncrement;
    }

    updateParticles() {
        for (let i = this.particles.length - 1; i >= 0; i--) {
            const particle = this.particles[i];
            particle.x += particle.velocityX;
            particle.y += particle.velocityY;
            particle.velocityY += 0.1; // Gravity for particles
            particle.life--;

            if (particle.life <= 0) {
                this.particles.splice(i, 1);
            }
        }
    }

    updateClouds() {
        this.clouds.forEach(cloud => {
            cloud.x -= cloud.speed;
            if (cloud.x + cloud.width < 0) {
                cloud.x = this.canvas.width;
                cloud.y = Math.random() * 150 + 50;
            }
        });
    }

    checkCollisions() {
        for (let obstacle of this.obstacles) {
            if (this.player.x < obstacle.x + obstacle.width &&
                this.player.x + this.player.width > obstacle.x &&
                this.player.y < obstacle.y + obstacle.height &&
                this.player.y + this.player.height > obstacle.y) {
                this.gameOver();
                return;
            }
        }
    }

    gameOver() {
        this.gameRunning = false;
        // Pause background music if it exists
        if (this.backgroundMusic && !this.backgroundMusic.paused) {
            this.backgroundMusic.pause();
        }

        // Check for high score
        if (this.score > this.highScore) {
            this.highScore = this.score;
            localStorage.setItem('geometryJumpHighScore', this.highScore);
            document.getElementById('newRecord').style.display = 'block';
        } else {
            document.getElementById('newRecord').style.display = 'none';
        }

        // Show game over screen
        document.getElementById('finalScore').textContent = this.score;
        document.getElementById('gameOver').style.display = 'block';
        document.getElementById('restartBtn').style.display = 'inline-block';

        this.updateHighScoreDisplay();
    }

    updateScoreDisplay() {
        document.getElementById('score').textContent = this.score;
    }

    updateHighScoreDisplay() {
        document.getElementById('high-score').textContent = this.highScore;
    }

    drawPlayer() {
        this.ctx.save();
        this.ctx.translate(this.player.x + this.player.width / 2, this.player.y + this.player.height / 2);
        this.ctx.rotate(this.player.rotation || 0);

        // Draw player cube with gradient
        const gradient = this.ctx.createLinearGradient(-this.player.width / 2, -this.player.height / 2,
                                                      this.player.width / 2, this.player.height / 2);
        gradient.addColorStop(0, this.player.color);
        gradient.addColorStop(1, '#45B7B8');

        this.ctx.fillStyle = gradient;
        this.ctx.fillRect(-this.player.width / 2, -this.player.height / 2, this.player.width, this.player.height);

        // Add border
        this.ctx.strokeStyle = '#FFFFFF';
        this.ctx.lineWidth = 2;
        this.ctx.strokeRect(-this.player.width / 2, -this.player.height / 2, this.player.width, this.player.height);

        this.ctx.restore();
    }
     drawObstacles() {
        this.obstacles.forEach(obstacle => {
            // Draw spike-like obstacle
            const gradient = this.ctx.createLinearGradient(obstacle.x, obstacle.y,
                                                          obstacle.x, obstacle.y + obstacle.height);
            gradient.addColorStop(0, obstacle.color);
            gradient.addColorStop(1, '#FF8E8E');

            this.ctx.fillStyle = gradient;

            // Draw spike shape (triangle pointing up)
            this.ctx.beginPath();
            this.ctx.moveTo(obstacle.x + obstacle.width / 2, obstacle.y); // Top point
            this.ctx.lineTo(obstacle.x, obstacle.y + obstacle.height); // Bottom left
            this.ctx.lineTo(obstacle.x + obstacle.width, obstacle.y + obstacle.height); // Bottom right
            this.ctx.closePath();
            this.ctx.fill();

            // Add border
            this.ctx.strokeStyle = '#FFFFFF';
            this.ctx.lineWidth = 2;
            this.ctx.stroke();
        });
    }

    drawGround() {
        // Draw ground with pattern
        const gradient = this.ctx.createLinearGradient(0, this.ground.y, 0, this.canvas.height);
        gradient.addColorStop(0, '#8B4513');
        gradient.addColorStop(1, '#A0522D');

        this.ctx.fillStyle = gradient;
        this.ctx.fillRect(0, this.ground.y, this.canvas.width, this.ground.height);

        // Add grass line
        this.ctx.strokeStyle = '#228B22';
        this.ctx.lineWidth = 3;
        this.ctx.beginPath();
        this.ctx.moveTo(0, this.ground.y);
        this.ctx.lineTo(this.canvas.width, this.ground.y);
        this.ctx.stroke();
    }

    drawClouds() {
        this.ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
        this.clouds.forEach(cloud => {
            this.ctx.beginPath();
            this.ctx.arc(cloud.x, cloud.y, cloud.width * 0.3, 0, Math.PI * 2);
            this.ctx.arc(cloud.x + cloud.width * 0.3, cloud.y, cloud.width * 0.35, 0, Math.PI * 2);
            this.ctx.arc(cloud.x + cloud.width * 0.6, cloud.y, cloud.width * 0.3, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }

    drawParticles() {
        this.particles.forEach(particle => {
            const alpha = particle.life / particle.maxLife;
            this.ctx.fillStyle = particle.color.replace(')', `, ${alpha})`).replace('hsl', 'hsla');
            this.ctx.beginPath();
            this.ctx.arc(particle.x, particle.y, particle.size, 0, Math.PI * 2);
            this.ctx.fill();
        });
    }

    draw() {
        // Clear canvas
        this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

        // Draw background elements
        this.drawClouds();
        this.drawGround();

        if (this.gameStarted) {
            this.drawPlayer();
            this.drawObstacles();
            this.drawParticles();
        } else {
            // Draw welcome message
            this.ctx.fillStyle = 'rgba(0, 0, 0, 0.7)';
            this.ctx.font = '24px Arial';
            this.ctx.textAlign = 'center';
            this.ctx.fillText('Click Start Game to Begin!', this.canvas.width / 2, this.canvas.height / 2);
        }
    }

    gameLoop() {
        if (this.gameRunning) {
            this.updatePlayer();
            this.updateObstacles();
            this.updateParticles();
            this.checkCollisions();
        }

        this.updateClouds();
        this.draw();

        requestAnimationFrame(() => this.gameLoop());
    }
}

// Initialize the game when the page loads
window.addEventListener('load', () => {
    new GeometryJump();
});
