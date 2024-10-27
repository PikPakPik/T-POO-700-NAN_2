defmodule TimeManagerWeb.ModelToJson do
  # Fonctions publiques

  # `serialize_data/2` prend une entité et des options, et sérialise l'entité en fonction de son type.
  def serialize_data(entity, opts \\ %{}) do
    case entity do
      # Retourne nil si l'entité est nil
      nil ->
        nil

      # Retourne une liste vide si l'entité est une liste vide
      [] ->
        []

      %{} = entity ->
        # Pour un map, transforme chaque champ en utilisant `process_field` et les regroupe dans un nouveau map
        Enum.into(Enum.map(fetch_fields(entity, opts), &process_field(entity, &1, opts)), %{})

      [_ | _] = entities ->
        # Pour une liste d'entités, applique récursivement `serialize_data` à chaque élément
        Enum.map(entities, &serialize_data(&1, opts))
    end
  end

  # `format_value/1` formate les valeurs DateTime ou retourne la valeur telle quelle.
  def format_value(%DateTime{} = value), do: Calendar.strftime(value, "%Y-%m-%d %H:%M:%S")
  def format_value(value), do: value

  # `handle_field/4` gère la sérialisation des champs, soit en préchargeant les associations, soit en formatant les champs simples.
  def handle_field(entity, field, :associations, opts) do
    serialize_data(
      Map.get(TimeManager.Repo.preload(entity, field), field),
      Map.merge(%{global: Map.get(opts, :global, %{})}, Map.get(opts, field, %{}))
    )
  end

  def handle_field(entity, field, :fields, _opts), do: format_value(Map.get(entity, field))

  # Fonctions privées

  # `process_field/3` traite chaque champ en appelant `handle_field`.
  defp process_field(entity, [field, type], opts),
    do: {field, handle_field(entity, field, type, opts)}

  # `show_field?/4` détermine si un champ doit être affiché, sauf pour les champs `inserted_at` et `updated_at`.
  defp show_field?(_entity, :password, _type, _opts), do: false
  defp show_field?(_entity, :inserted_at, _type, _opts), do: false
  defp show_field?(_entity, :updated_at, _type, _opts), do: false
  defp show_field?(_entity, _field, _type, _opts), do: true

  # `field_included?/2` vérifie si un champ est inclus en se basant sur les options fournies.
  defp field_included?(field, opts) do
    case opts do
      nil ->
        true

      opts ->
        field not in Map.get(opts, :excluded, []) and
          field_included?(field, Map.get(opts, :global, nil))
    end
  end

  # `fetch_field_types/3` récupère les types de champs (associations ou champs simples) qui doivent être inclus.
  defp fetch_field_types(entity, type, opts) do
    entity.__struct__.__schema__(type)
    |> Enum.filter(&field_included?(&1, opts))
    |> Enum.filter(&show_field?(entity, &1, type, opts))
    |> Enum.map(fn item -> [item, type] end)
  end

  # `fetch_fields/2` récupère tous les champs à traiter, en incluant les associations si spécifié.
  defp fetch_fields(entity, opts) do
    associations =
      case Map.get(opts, :associations, false) do
        true -> fetch_field_types(entity, :associations, opts)
        false -> []
      end

    fetch_field_types(entity, :fields, opts)
    |> Enum.concat(associations)
  end
end
