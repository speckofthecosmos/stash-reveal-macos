// ==UserScript==
// @name         Stash Reveal in Finder (Clean)
// @namespace    http://tampermonkey.net/
// @version      1.4
// @description  Adds a "Reveal in Finder" button to file paths in Stash (No Duplicates)
// @author       SpeckOfTheCosmos
// @match        http://localhost:9999/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    function addRevealButton() {
        // Broad search to ensure we find the path
        const potentialPaths = document.querySelectorAll('dd, span, div, .scene-file-info, .file-info-path');

        potentialPaths.forEach(pathEl => {
             // 1. Skip if this specific element was already processed
             if (pathEl.dataset.stashRevealProcessed) return;

             // 2. CRITICAL FIX: Skip if a child element already has the button
             // This prevents the "Double Icon" issue (parent and child both getting buttons)
             if (pathEl.querySelector('.stash-reveal-btn')) return;

             const pathText = pathEl.textContent.trim();
             
             // 3. Strict validation to ensure it's a file path
             if (!pathText || pathText.length < 5 || pathText.includes('\n')) return;
             if (!pathText.startsWith('/') && !pathText.startsWith('file://')) return;

             // 4. Mark as processed
             pathEl.dataset.stashRevealProcessed = 'true';

             // 5. Clean Path
             let cleanPath = pathText;
             if (cleanPath.startsWith('file://')) {
                 cleanPath = cleanPath.replace('file://', '');
             }

             // 6. Create Button
             const btn = document.createElement('a');
             btn.innerHTML = ' 📂'; 
             btn.title = 'Reveal in Finder';
             btn.className = 'stash-reveal-btn';
             btn.style.marginLeft = '10px';
             btn.style.cursor = 'pointer';
             btn.style.textDecoration = 'none';
             btn.style.fontSize = '1.2em';
             
             // Protocol link: stashreveal://[REMOTE_PATH]
             // We ensure the path is URI encoded so spaces become %20, etc.
             btn.href = `stashreveal://${encodeURI(cleanPath)}`; 

             pathEl.appendChild(btn);
        });
    }

    // Run periodically
    setInterval(addRevealButton, 2000); 

})();