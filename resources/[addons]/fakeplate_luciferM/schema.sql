-- Table des inventaires des joueurs
CREATE TABLE IF NOT EXISTS `user_inventory` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL, -- Identifiant unique du joueur (par exemple SteamID)
    `item` VARCHAR(50) NOT NULL,       -- Nom de l'item (usb_black, fakeplate, etc.)
    `count` INT NOT NULL DEFAULT 0,    -- Quantité de l'item dans l'inventaire
    `label` VARCHAR(100) NOT NULL,     -- Label de l'item pour l'affichage
    `weight` INT NOT NULL DEFAULT 0,   -- Poids de l'item
    `description` TEXT,                -- Description de l'item
    `image` VARCHAR(100) DEFAULT NULL, -- Lien vers l'image de l'item dans ox_inventory
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Date de création
);

-- Table pour les coffres
CREATE TABLE IF NOT EXISTS `user_stashes` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `stash_name` VARCHAR(50) NOT NULL, -- Nom du coffre
    `identifier` VARCHAR(50) NOT NULL, -- Identifiant du joueur qui possède le coffre
    `item` VARCHAR(50) NOT NULL,       -- Nom de l'item dans le coffre (usb_black, metal, plastic, etc.)
    `count` INT NOT NULL DEFAULT 0,    -- Quantité de l'item dans le coffre
    `weight` INT NOT NULL DEFAULT 0,   -- Poids de l'item
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Date de création
);

-- Table pour enregistrer les matériaux collectés
CREATE TABLE IF NOT EXISTS `collected_materials` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL, -- Identifiant du joueur
    `metal_count` INT DEFAULT 0,       -- Quantité de métal collectée
    `plastic_count` INT DEFAULT 0,     -- Quantité de plastique collectée
    `collected_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Date de collecte
);

-- Table pour les transactions des magasins (optionnel)
CREATE TABLE IF NOT EXISTS `shop_transactions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL, -- Identifiant du joueur
    `item` VARCHAR(50) NOT NULL,       -- Nom de l'item acheté (usb_black, etc.)
    `price` INT NOT NULL,              -- Prix de l'item en argent sale
    `transaction_date` TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Date de la transaction
);

-- Table pour les fabrications
CREATE TABLE IF NOT EXISTS `crafting_history` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `identifier` VARCHAR(50) NOT NULL, -- Identifiant du joueur
    `item` VARCHAR(50) NOT NULL,       -- Nom de l'item fabriqué (fakeplate, etc.)
    `metal_used` INT NOT NULL,         -- Quantité de métal utilisée
    `plastic_used` INT NOT NULL,       -- Quantité de plastique utilisée
    `crafted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Date de la fabrication
);
