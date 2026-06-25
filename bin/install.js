#!/usr/bin/env node
"use strict";

/*
 * iitb-apping installer
 * Copies the iitb_apping Claude skill into the user's Claude skills directory
 * (~/.claude/skills/iitb_apping). Zero dependencies.
 *
 * Usage:
 *   npx github:nimayshah123/iitb-apping          # install (or update)
 *   npx github:nimayshah123/iitb-apping --force  # overwrite without prompting
 *   npx github:nimayshah123/iitb-apping --uninstall
 */

const fs = require("fs");
const os = require("os");
const path = require("path");

const SKILL_NAME = "iitb_apping";
const args = process.argv.slice(2);
const force = args.includes("--force") || args.includes("-f");
const uninstall = args.includes("--uninstall");

const home = os.homedir();
const skillsDir = path.join(home, ".claude", "skills");
const target = path.join(skillsDir, SKILL_NAME);
const source = path.join(__dirname, "..", "skill");

function log(msg) {
  process.stdout.write(msg + "\n");
}

function fail(msg) {
  process.stderr.write("\n  ✗ " + msg + "\n");
  process.exit(1);
}

log("");
log("  iitb_apping — Claude skill installer");
log("  " + "-".repeat(38));

if (uninstall) {
  if (!fs.existsSync(target)) {
    log("  Nothing to remove — " + target + " does not exist.");
    process.exit(0);
  }
  fs.rmSync(target, { recursive: true, force: true });
  log("  ✓ Removed " + target);
  process.exit(0);
}

if (!fs.existsSync(source)) {
  fail("Could not find the skill payload at " + source + " (broken package?).");
}

// Make sure ~/.claude/skills exists.
fs.mkdirSync(skillsDir, { recursive: true });

if (fs.existsSync(target) && !force) {
  log("  A skill is already installed at:");
  log("    " + target);
  log("");
  log("  Re-run with --force to overwrite it:");
  log("    npx github:nimayshah123/iitb-apping --force");
  process.exit(0);
}

if (fs.existsSync(target)) {
  fs.rmSync(target, { recursive: true, force: true });
}

fs.cpSync(source, target, { recursive: true });

log("  ✓ Installed the iitb_apping skill to:");
log("    " + target);
log("");
log("  Next steps:");
log("    1. Make sure kimi-webbridge is installed and running (the skill checks this).");
log("    2. Log into https://webmail.iitb.ac.in in that browser.");
log("    3. In Claude Code, run:  /iitb_apping");
log('       or say: "use iitb_apping to find professors at <university> in <field> and email them"');
log("");
