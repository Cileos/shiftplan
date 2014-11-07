# in 3a8e0306eb45fa02b2655e7c37d1631e3bf3c1b6, we modified the migrations (sic)
# to created uniqUE indices on :slug. Before, the mistyped option was ignored.
# For Account, this is sort of OK, but Organization and Plan are scoped to
# their Account or Organization, respectivly. Problem: when scoped, friendly_id
# does not add ids/UUIDs to resolve conflicts, resulting in a
# PG::UniqueViolation.

class ScopeSlugUniqueIndices < ActiveRecord::Migration
  def up
    remove_index :accounts, :slug
    add_index :accounts, :slug, unique: true

    remove_index :organizations, :slug
    add_index :organizations, [:slug, :account_id], unique: true

    remove_index :plans, :slug
    add_index :plans, [:slug, :organization_id], unique: true
  end

  def down
    # these indices miss the scope from their models and are therefor bad

    remove_index :accounts, :slug
    add_index :accounts, :slug, unique: true

    remove_index :organizations, :slug
    add_index :organizations, :slug, unique: true

    remove_index :plans, :slug
    add_index :plans, :slug, unique: true
  end
end
